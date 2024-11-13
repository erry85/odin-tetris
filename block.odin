package game

import rl "vendor:raylib"

BlockType :: enum {
	L = 1,
	J,
	I,
	O,
	S,
	T,
	Z,
}

Block :: struct {
	id:              i32,
	cells:           map[i32][dynamic]Position,
	cellSize:        i32,
	rotationState:   i32,
	colors:          [GridColors]rl.Color,
	type:            BlockType,
	rowOffset:       i32,
	colOffset:       i32,
	draw:            proc(_: Block, _: i32, _: i32),
	move:            proc(_: ^Block, _: i32, _: i32),
	getCellPosition: proc(_: Block) -> [dynamic]Position,
	rotate:          proc(_: ^Block),
	undoRotate:      proc(_: ^Block),
	destroy:         proc(_: ^Block),
}

create_IBlock :: proc() -> Block {
	b := create_block()
	b.id = cast(i32)BlockType.I
	b.type = BlockType.I
	b->move(-1, 0)
	b.cells[0] = {
		Position{row = 1, col = 0},
		Position{row = 1, col = 1},
		Position{row = 1, col = 2},
		Position{row = 1, col = 3},
	}

	b.cells[1] = {
		Position{row = 0, col = 2},
		Position{row = 1, col = 2},
		Position{row = 2, col = 2},
		Position{row = 3, col = 2},
	}

	b.cells[2] = {
		Position{row = 2, col = 0},
		Position{row = 2, col = 1},
		Position{row = 2, col = 2},
		Position{row = 2, col = 3},
	}

	b.cells[3] = {
		Position{row = 0, col = 1},
		Position{row = 1, col = 1},
		Position{row = 2, col = 1},
		Position{row = 3, col = 1},
	}

	return b
}

create_JBlock :: proc() -> Block {
	b := create_block()
	b.id = cast(i32)BlockType.J
	b.type = BlockType.J
	b.cells[0] = {
		Position{row = 0, col = 0},
		Position{row = 1, col = 0},
		Position{row = 1, col = 1},
		Position{row = 1, col = 2},
	}

	b.cells[1] = {
		Position{row = 0, col = 1},
		Position{row = 0, col = 2},
		Position{row = 1, col = 1},
		Position{row = 2, col = 1},
	}

	b.cells[2] = {
		Position{row = 1, col = 0},
		Position{row = 1, col = 1},
		Position{row = 1, col = 2},
		Position{row = 2, col = 2},
	}

	b.cells[3] = {
		Position{row = 0, col = 1},
		Position{row = 1, col = 1},
		Position{row = 2, col = 0},
		Position{row = 2, col = 1},
	}

	return b
}

create_LBlock :: proc() -> Block {
	b := create_block()
	b.id = cast(i32)BlockType.L
	b.type = BlockType.L
	b.cells[0] = {
		Position{row = 0, col = 2},
		Position{row = 1, col = 0},
		Position{row = 1, col = 1},
		Position{row = 1, col = 2},
	}

	b.cells[1] = {
		Position{row = 0, col = 1},
		Position{row = 1, col = 1},
		Position{row = 2, col = 1},
		Position{row = 2, col = 2},
	}

	b.cells[2] = {
		Position{row = 1, col = 0},
		Position{row = 1, col = 1},
		Position{row = 1, col = 2},
		Position{row = 2, col = 0},
	}

	b.cells[3] = {
		Position{row = 0, col = 0},
		Position{row = 0, col = 1},
		Position{row = 1, col = 1},
		Position{row = 2, col = 1},
	}
	return b
}

create_OBlock :: proc() -> Block {
	b := create_block()
	b.id = cast(i32)BlockType.O
	b.type = BlockType.O
	b->move(0, 1)
	b.cells[0] = {
		Position{row = 0, col = 0},
		Position{row = 0, col = 1},
		Position{row = 1, col = 0},
		Position{row = 1, col = 1},
	}

	return b
}

create_SBlock :: proc() -> Block {
	b := create_block()
	b.id = cast(i32)BlockType.S
	b.type = BlockType.S
	b.cells[0] = {
		Position{row = 0, col = 1},
		Position{row = 0, col = 2},
		Position{row = 1, col = 0},
		Position{row = 1, col = 1},
	}

	b.cells[1] = {
		Position{row = 0, col = 1},
		Position{row = 1, col = 1},
		Position{row = 1, col = 2},
		Position{row = 2, col = 2},
	}

	b.cells[2] = {
		Position{row = 1, col = 1},
		Position{row = 1, col = 2},
		Position{row = 2, col = 0},
		Position{row = 2, col = 1},
	}

	b.cells[3] = {
		Position{row = 0, col = 0},
		Position{row = 1, col = 0},
		Position{row = 1, col = 1},
		Position{row = 2, col = 1},
	}

	return b
}

create_TBlock :: proc() -> Block {
	b := create_block()
	b.id = cast(i32)BlockType.T
	b.type = BlockType.T
	b.cells[0] = {
		Position{row = 0, col = 1},
		Position{row = 1, col = 0},
		Position{row = 1, col = 1},
		Position{row = 1, col = 2},
	}

	b.cells[1] = {
		Position{row = 0, col = 1},
		Position{row = 1, col = 1},
		Position{row = 1, col = 2},
		Position{row = 2, col = 1},
	}

	b.cells[2] = {
		Position{row = 1, col = 0},
		Position{row = 1, col = 1},
		Position{row = 1, col = 2},
		Position{row = 2, col = 1},
	}

	b.cells[3] = {
		Position{row = 0, col = 1},
		Position{row = 1, col = 0},
		Position{row = 1, col = 1},
		Position{row = 2, col = 1},
	}

	return b
}

create_ZBlock :: proc() -> Block {
	b := create_block()
	b.id = cast(i32)BlockType.Z
	b.type = BlockType.Z
	b.cells[0] = {
		Position{row = 0, col = 0},
		Position{row = 0, col = 1},
		Position{row = 1, col = 1},
		Position{row = 1, col = 2},
	}

	b.cells[1] = {
		Position{row = 0, col = 2},
		Position{row = 1, col = 1},
		Position{row = 1, col = 2},
		Position{row = 2, col = 1},
	}

	b.cells[2] = {
		Position{row = 1, col = 0},
		Position{row = 1, col = 1},
		Position{row = 2, col = 1},
		Position{row = 2, col = 2},
	}

	b.cells[3] = {
		Position{row = 0, col = 1},
		Position{row = 1, col = 0},
		Position{row = 1, col = 1},
		Position{row = 2, col = 0},
	}

	return b
}

@(private)
create_block :: proc() -> Block {
	b: Block
	b.cellSize = 30
	b.rotationState = 0
	b.colors = gridColorsVector
	b.rowOffset = 0
	b.colOffset = 0
	b.draw = block_draw
	b.move = block_move
	b.getCellPosition = block_getCellPosition
	b.rotate = block_rotate
	b.undoRotate = block_undoRotate
	b.destroy = block_destroy
	b->move(0, 3)

	return b
}

@(private)
block_draw :: proc(b: Block, offsetX: i32, offsetY: i32) {
	tiles: [dynamic]Position = b->getCellPosition()
	for tile in tiles {
		rl.DrawRectangle(
			tile.col * b.cellSize + offsetX,
			tile.row * b.cellSize + offsetY,
			b.cellSize - 1,
			b.cellSize - 1,
			b.colors[cast(GridColors)b.id],
		)
	}
}

@(private)
block_move :: proc(b: ^Block, rows: i32, cols: i32) {
	b.rowOffset += rows
	b.colOffset += cols
}

@(private)
block_getCellPosition :: proc(b: Block) -> [dynamic]Position {
	tiles: [dynamic]Position = b.cells[b.rotationState]
	movedTiles: [dynamic]Position
	defer delete(movedTiles)

	for tile in tiles {
		newPos: Position = {
			row = tile.row + b.rowOffset,
			col = tile.col + b.colOffset,
		}
		append(&movedTiles, newPos)
	}
	return movedTiles
}

@(private)
block_rotate :: proc(b: ^Block) {
	b.rotationState += 1
	if b.rotationState == i32(len(b.cells)) {
		b.rotationState = 0
	}
}

@(private)
block_undoRotate :: proc(b: ^Block) {
	b.rotationState -= 1
	if b.rotationState == -1 {
		b.rotationState = i32(len(b.cells)) - 1
	}
}

@(private)
block_destroy :: proc(b: ^Block) {
	for _, pos in b.cells {
		delete(pos)
	}
	delete(b.cells)
}
