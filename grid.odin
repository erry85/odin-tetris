package game

import "core:fmt"
import rl "vendor:raylib"

Grid :: struct {
	data:          [20][10]i32,
	numRows:       i32,
	numCols:       i32,
	cellSize:      i32,
	print:         proc(_: Grid),
	draw:          proc(_: Grid),
	isCellOutside: proc(_: Grid, _: i32, _: i32) -> bool,
	isCellEmpty:   proc(_: Grid, _: i32, _: i32) -> bool,
	isRowFull:     proc(_: Grid, _: i32) -> bool,
	clearRow:      proc(_: ^Grid, _: i32),
	moveRowDown:   proc(_: ^Grid, _: i32, _: i32),
	clearFullRows: proc(_: ^Grid) -> i32,
}

create_grid :: proc() -> Grid {
	g: Grid
	g.print = grid_print
	g.draw = grid_draw
	g.isCellOutside = grid_isCellOutside
	g.isCellEmpty = grid_isCellEmpty
	g.isRowFull = grid_isRowFull
	g.clearRow = grid_clearRow
	g.moveRowDown = grid_moveRowDown
	g.clearFullRows = grid_clearFullRows
	g.numRows = 20
	g.numCols = 10
	g.cellSize = 30

	for row in 0 ..< g.numRows {
		for col in 0 ..< g.numCols {
			g.data[row][col] = 0
		}
	}

	return g
}

@(private)
grid_print :: proc(g: Grid) {
	for row in 0 ..< g.numRows {
		for col in 0 ..< g.numCols {
			fmt.printf("%i ", g.data[row][col])
		}
		fmt.println("")
	}
}

@(private)
grid_draw :: proc(g: Grid) {
	for row in 0 ..< g.numRows {
		for col in 0 ..< g.numCols {
			cellValue := g.data[row][col]
			rl.DrawRectangle(
				col * g.cellSize + 11,
				row * g.cellSize + 11,
				g.cellSize - 1,
				g.cellSize - 1,
				gridColorsVector[cast(GridColors)cellValue],
			)
		}
	}
}

@(private)
grid_isCellOutside :: proc(g: Grid, row: i32, col: i32) -> bool {
	if row >= 0 && row < g.numRows && col >= 0 && col < g.numCols {
		return false
	}
	return true
}

@(private)
grid_isCellEmpty :: proc(g: Grid, row: i32, col: i32) -> bool {
	if g.data[row][col] == 0 {
		return true
	}
	return false
}

@(private)
grid_isRowFull :: proc(g: Grid, row: i32) -> bool {
	for column: i32 = 0; column < g.numCols; column += 1 {
		if g.data[row][column] == 0 {
			return false
		}
	}

	return true
}

@(private)
grid_clearRow :: proc(g: ^Grid, row: i32) {
	for column: i32 = 0; column < g.numCols; column += 1 {
		g.data[row][column] = 0
	}
}

@(private)
grid_moveRowDown :: proc(g: ^Grid, row: i32, numRows: i32) {
	for column: i32 = 0; column < g.numCols; column += 1 {
		g.data[row + numRows][column] = g.data[row][column]
		g.data[row][column] = 0
	}
}

@(private)
grid_clearFullRows :: proc(g: ^Grid) -> i32 {
	completed: i32 = 0
	for row := g.numRows - 1; row >= 0; row -= 1 {
		if g->isRowFull(row) {
			g->clearRow(row)
			completed += 1
		} else if completed > 0 {
			g->moveRowDown(row, completed)
		}
	}
	return completed
}
