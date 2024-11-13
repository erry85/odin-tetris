package game

import "core:math/rand"
import rl "vendor:raylib"

Game :: struct {
	grid:           Grid,
	blocks:         [dynamic]Block,
	currBlock:      Block,
	nextBlock:      Block,
	IBlock:         Block,
	JBlock:         Block,
	LBlock:         Block,
	OBlock:         Block,
	SBlock:         Block,
	TBlock:         Block,
	ZBlock:         Block,
	gameOver:       bool,
	score:          i32,
	music:          rl.Music,
	rotateSound:    rl.Sound,
	clearSound:     rl.Sound,
	initBlocks:     proc(_: ^Game),
	destroyBlocks:  proc(_: ^Game),
	getRandomBlock: proc(_: ^Game) -> Block,
	draw:           proc(_: ^Game),
	handleInput:    proc(_: ^Game),
	moveBlockLeft:  proc(_: ^Game),
	moveBlockRight: proc(_: ^Game),
	moveBlockDown:  proc(_: ^Game),
	rotateBlock:    proc(_: ^Game),
	lockBlock:      proc(_: ^Game),
	blockFits:      proc(_: Game) -> bool,
	isBlockOutside: proc(_: Game) -> bool,
	reset:          proc(_: ^Game),
	updateScore:    proc(_: ^Game, _: i32, _: i32),
	destroy:        proc(_: ^Game),
}

create_game :: proc() -> Game {
	g: Game
	g.initBlocks = game_initBlocks
	g.destroyBlocks = game_destroyBlocks
	g.getRandomBlock = game_getRandomBlock
	g.draw = game_draw
	g.handleInput = game_handleInput
	g.moveBlockLeft = game_moveBlockLeft
	g.moveBlockRight = game_moveBlockRight
	g.moveBlockDown = game_moveBlockDown
	g.rotateBlock = game_rotateBlock
	g.lockBlock = game_lockBlock
	g.blockFits = game_blockFits
	g.isBlockOutside = game_isBlockOutside
	g.reset = game_reset
	g.updateScore = game_updateScore
	g.destroy = game_destroy

	g.grid = create_grid()
	g.IBlock = create_IBlock()
	g.JBlock = create_JBlock()
	g.LBlock = create_LBlock()
	g.OBlock = create_OBlock()
	g.SBlock = create_SBlock()
	g.TBlock = create_TBlock()
	g.ZBlock = create_ZBlock()
	g->initBlocks()
	g.currBlock = g->getRandomBlock()
	g.nextBlock = g->getRandomBlock()
	rl.InitAudioDevice()
	g.music = rl.LoadMusicStream("assets/sounds/music.mp3")
	rl.PlayMusicStream(g.music)
	g.rotateSound = rl.LoadSound("assets/sounds/rotate.mp3")
	g.clearSound = rl.LoadSound("assets/sounds/clear.mp3")

	return g
}

@(private)
game_initBlocks :: proc(g: ^Game) {
	append(&g.blocks, g.IBlock, g.JBlock, g.LBlock, g.OBlock, g.SBlock, g.TBlock, g.ZBlock)
}

@(private)
game_destroyBlocks :: proc(g: ^Game) {
	delete_dynamic_array(g.blocks)
	g.IBlock->destroy()
	g.JBlock->destroy()
	g.LBlock->destroy()
	g.OBlock->destroy()
	g.SBlock->destroy()
	g.TBlock->destroy()
	g.ZBlock->destroy()
}

@(private)
game_getRandomBlock :: proc(g: ^Game) -> Block {
	if len(g.blocks) == 0 {
		g->initBlocks()
	}
	randomIndex := rand.int_max(len(g.blocks))
	block: Block = g.blocks[randomIndex]
	unordered_remove(&g.blocks, randomIndex)
	return block
}

@(private)
game_draw :: proc(g: ^Game) {
	g.grid->draw()
	g.currBlock->draw(11, 11)
	switch (g.nextBlock.id) {
	case 3:
		g.nextBlock->draw(255, 290)
	case 4:
		g.nextBlock->draw(255, 280)
	case:
		g.nextBlock->draw(270, 270)
	}
}

@(private)
game_isBlockOutside :: proc(g: Game) -> bool {
	tiles: [dynamic]Position = g.currBlock->getCellPosition()
	for tile in tiles {
		if g.grid->isCellOutside(tile.row, tile.col) {
			return true
		}
	}
	return false
}

@(private)
game_handleInput :: proc(g: ^Game) {
	keyPressed := rl.GetKeyPressed()
	if g.gameOver && keyPressed == .SPACE {
		g.gameOver = false
		g->reset()
	}

	#partial switch (keyPressed) {
	case .LEFT:
		g->moveBlockLeft()
	case .RIGHT:
		g->moveBlockRight()
	case .DOWN:
		g->moveBlockDown()
		if !g.gameOver {
			g->updateScore(0, 1)
		}
	case .UP:
		g->rotateBlock()
	}
}

@(private)
game_moveBlockLeft :: proc(g: ^Game) {
	if !g.gameOver {
		g.currBlock->move(0, -1)
		if g->isBlockOutside() || !g->blockFits() {
			g.currBlock->move(0, 1)
		}
	}
}

@(private)
game_moveBlockRight :: proc(g: ^Game) {
	if !g.gameOver {
		g.currBlock->move(0, 1)
		if g->isBlockOutside() || !g->blockFits() {
			g.currBlock->move(0, -1)
		}
	}
}

@(private)
game_moveBlockDown :: proc(g: ^Game) {
	if !g.gameOver {
		g.currBlock->move(1, 0)
		if g->isBlockOutside() || !g->blockFits() {
			g.currBlock->move(-1, 0)
			g->lockBlock()
		}
	}
}

@(private)
game_rotateBlock :: proc(g: ^Game) {
	if !g.gameOver {
		g.currBlock->rotate()
		if g->isBlockOutside() || !g->blockFits() {
			g.currBlock->undoRotate()
		} else {
			rl.PlaySound(g.rotateSound)
		}
	}
}

@(private)
game_blockFits :: proc(g: Game) -> bool {
	tiles: [dynamic]Position = g.currBlock->getCellPosition()

	for tile in tiles {
		if !g.grid->isCellEmpty(tile.row, tile.col) {
			return false
		}
	}

	return true
}

@(private)
game_lockBlock :: proc(g: ^Game) {
	tiles: [dynamic]Position = g.currBlock->getCellPosition()

	for tile in tiles {
		g.grid.data[tile.row][tile.col] = g.currBlock.id
	}

	g.currBlock = g.nextBlock

	if !g->blockFits() {
		g.gameOver = true
	}

	g.nextBlock = g->getRandomBlock()
	rowsClear: i32 = g.grid->clearFullRows()
	if rowsClear > 0 {
		rl.PlaySound(g.clearSound)
		g->updateScore(rowsClear, 0)
	}
}

@(private)
game_reset :: proc(g: ^Game) {
	g.grid = create_grid()
	g->initBlocks()
	g.currBlock = g->getRandomBlock()
	g.nextBlock = g->getRandomBlock()
	g.score = 0
}

@(private)
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

@(private)
game_destroy :: proc(g: ^Game) {
	g->destroyBlocks()
	rl.CloseAudioDevice()
	rl.UnloadMusicStream(g.music)
	rl.UnloadSound(g.rotateSound)
	rl.UnloadSound(g.clearSound)
}
