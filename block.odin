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
	id:            i32,
	cells:         map[i32][dynamic]Position,
	cellSize:      i32,
	rotationState: i32,
	colors:        [GridColors]rl.Color,
	type:          BlockType,
	rowOffset:     i32,
	colOffset:     i32,
}

block_init :: proc(b: ^Block, type: BlockType) {
	b.id = cast(i32)type
	b.cellSize = 30
	b.rotationState = 0
	b.colors = gridColorsVector
	b.type = type
	b.rowOffset = 0
	b.colOffset = 0
	block_move(b, 0, 3)

	if type == .L {
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
	} else if type == .J {
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
	} else if type == .I {
		block_move(b, -1, 0)
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
	} else if type == .O {
		b.cells[0] = {
			Position{row = 0, col = 0},
			Position{row = 0, col = 1},
			Position{row = 1, col = 0},
			Position{row = 1, col = 1},
		}
		block_move(b, 0, 1)
	} else if type == .S {
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
	} else if type == .T {
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
	} else if type == .Z {
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
	}

}

block_destroy :: proc(b: ^Block) {
	for _, pos in b.cells {
		delete(pos)
	}
	delete(b.cells)
}

block_draw :: proc(b: Block, offsetX: i32, offsetY: i32) {
	tiles: [dynamic]Position = block_getCellPosition(b)
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

block_move :: proc(b: ^Block, rows: i32, cols: i32) {
	b.rowOffset += rows
	b.colOffset += cols
}

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

block_rotate :: proc(b: ^Block) {
	b.rotationState += 1
	if b.rotationState == i32(len(b.cells)) {
		b.rotationState = 0
	}
}

block_undoRotation :: proc(b: ^Block) {
	b.rotationState -= 1
	if b.rotationState == -1 {
		b.rotationState = i32(len(b.cells)) - 1
	}
}
