package game

import "core:math/rand"
import rl "vendor:raylib"

Game :: struct {
	grid:        Grid,
	blocks:      [dynamic]Block,
	currBlock:   Block,
	nextBlock:   Block,
	IBlock:      Block,
	JBlock:      Block,
	LBlock:      Block,
	OBlock:      Block,
	SBlock:      Block,
	TBlock:      Block,
	ZBlock:      Block,
	gameOver:    bool,
	score:       i32,
	music:       rl.Music,
	rotateSound: rl.Sound,
	clearSound:  rl.Sound,
}

game_init :: proc(g: ^Game) {
	grid_init(&g.grid)
	block_init(&g.IBlock, .I)
	block_init(&g.JBlock, .J)
	block_init(&g.LBlock, .L)
	block_init(&g.OBlock, .O)
	block_init(&g.SBlock, .S)
	block_init(&g.TBlock, .T)
	block_init(&g.ZBlock, .Z)
	game_initBlocks(g)
	g.currBlock = game_getRandomBlock(g)
	g.nextBlock = game_getRandomBlock(g)
	rl.InitAudioDevice()
	g.music = rl.LoadMusicStream("assets/sounds/music.mp3")
	rl.PlayMusicStream(g.music)
	g.rotateSound = rl.LoadSound("assets/sounds/rotate.mp3")
	g.clearSound = rl.LoadSound("assets/sounds/clear.mp3")
}

game_initBlocks :: proc(g: ^Game) {
	append(&g.blocks, g.IBlock, g.JBlock, g.LBlock, g.OBlock, g.SBlock, g.TBlock, g.ZBlock)
}

game_destroyBlocks :: proc(g: ^Game) {
	delete_dynamic_array(g.blocks)
	block_destroy(&g.IBlock)
	block_destroy(&g.JBlock)
	block_destroy(&g.LBlock)
	block_destroy(&g.OBlock)
	block_destroy(&g.SBlock)
	block_destroy(&g.TBlock)
	block_destroy(&g.ZBlock)
}

game_getRandomBlock :: proc(g: ^Game) -> Block {
	if len(g.blocks) == 0 {
		game_initBlocks(g)
	}
	randomIndex := rand.int_max(len(g.blocks))
	block: Block = g.blocks[randomIndex]
	unordered_remove(&g.blocks, randomIndex)
	return block
}

game_draw :: proc(g: ^Game) {
	grid_draw(g.grid)
	block_draw(g.currBlock, 11, 11)
	switch (g.nextBlock.id) {
	case 3:
		block_draw(g.nextBlock, 255, 290)
	case 4:
		block_draw(g.nextBlock, 255, 280)
	case:
		block_draw(g.nextBlock, 270, 270)
	}
}

game_isBlockOutside :: proc(g: Game) -> bool {
	tiles: [dynamic]Position = block_getCellPosition(g.currBlock)
	for tile in tiles {
		if grid_isCellOutside(g.grid, tile.row, tile.col) {
			return true
		}
	}
	return false
}

game_handleInput :: proc(g: ^Game) {
	keyPressed := rl.GetKeyPressed()
	if g.gameOver && keyPressed == .SPACE {
		g.gameOver = false
		game_reset(g)
	}

	#partial switch (keyPressed) {
	case .LEFT:
		game_moveBlockLeft(g)
	case .RIGHT:
		game_moveBlockRight(g)
	case .DOWN:
		game_moveBlockDown(g)
		if !g.gameOver {
			game_updateScore(g, 0, 1)
		}
	case .UP:
		game_rotateBlock(g)
	}
}

game_moveBlockLeft :: proc(g: ^Game) {
	if !g.gameOver {
		block_move(&g.currBlock, 0, -1)
		if game_isBlockOutside(g^) || !game_blockFits(g^) {
			block_move(&g.currBlock, 0, 1)
		}
	}
}

game_moveBlockRight :: proc(g: ^Game) {
	if !g.gameOver {
		block_move(&g.currBlock, 0, 1)
		if game_isBlockOutside(g^) || !game_blockFits(g^) {
			block_move(&g.currBlock, 0, -1)
		}
	}
}

game_moveBlockDown :: proc(g: ^Game) {
	if !g.gameOver {
		block_move(&g.currBlock, 1, 0)
		if game_isBlockOutside(g^) || !game_blockFits(g^) {
			block_move(&g.currBlock, -1, 0)
			game_lockBlock(g)
		}
	}
}

game_rotateBlock :: proc(g: ^Game) {
	if !g.gameOver {
		block_rotate(&g.currBlock)
		if game_isBlockOutside(g^) || !game_blockFits(g^) {
			block_undoRotation(&g.currBlock)
		} else {
			rl.PlaySound(g.rotateSound)
		}
	}
}

game_blockFits :: proc(g: Game) -> bool {
	tiles: [dynamic]Position = block_getCellPosition(g.currBlock)

	for tile in tiles {
		if !grid_isCellEmpty(g.grid, tile.row, tile.col) {
			return false
		}
	}

	return true
}

game_lockBlock :: proc(g: ^Game) {
	tiles: [dynamic]Position = block_getCellPosition(g.currBlock)

	for tile in tiles {
		g.grid.data[tile.row][tile.col] = g.currBlock.id
	}

	g.currBlock = g.nextBlock

	if !game_blockFits(g^) {
		g.gameOver = true
	}

	g.nextBlock = game_getRandomBlock(g)
	rowsClear: i32 = grid_clearFullRows(&g.grid)
	if rowsClear > 0 {
		rl.PlaySound(g.clearSound)
		game_updateScore(g, rowsClear, 0)
	}
}

game_reset :: proc(g: ^Game) {
	grid_init(&g.grid)
	game_initBlocks(g)
	g.currBlock = game_getRandomBlock(g)
	g.nextBlock = game_getRandomBlock(g)
	g.score = 0
}

game_updateScore :: proc(g: ^Game, linesCleared: i32, moveDownPoints: i32) {
	switch (linesCleared) {
	case 1:
		g.score += 100
	case 2:
		g.score += 300
	case 3:
		g.score += 500
	}

	g.score += moveDownPoints
}

game_destroy :: proc(g: ^Game) {
	game_destroyBlocks(g)
	rl.CloseAudioDevice()
	rl.UnloadMusicStream(g.music)
	rl.UnloadSound(g.rotateSound)
	rl.UnloadSound(g.clearSound)
}
