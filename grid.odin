package game

import "core:fmt"
import rl "vendor:raylib"

Grid :: struct {
	data:     [20][10]i32,
	numRows:  i32,
	numCols:  i32,
	cellSize: i32,
}

grid_init :: proc(g: ^Grid) {
	g.numRows = 20
	g.numCols = 10
	g.cellSize = 30

	for row in 0 ..< g.numRows {
		for col in 0 ..< g.numCols {
			g.data[row][col] = 0
		}
	}
}

grid_print :: proc(g: Grid) {
	for row in 0 ..< g.numRows {
		for col in 0 ..< g.numCols {
			fmt.printf("%i ", g.data[row][col])
		}
		fmt.println("")
	}
}

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

grid_isCellOutside :: proc(g: Grid, row: i32, col: i32) -> bool {
	if row >= 0 && row < g.numRows && col >= 0 && col < g.numCols {
		return false
	}
	return true
}

grid_isCellEmpty :: proc(g: Grid, row: i32, col: i32) -> bool {
	if g.data[row][col] == 0 {
		return true
	}
	return false
}

grid_isRowFull :: proc(g: Grid, row: i32) -> bool {
	for column: i32 = 0; column < g.numCols; column += 1 {
		if g.data[row][column] == 0 {
			return false
		}
	}

	return true
}

grid_clearRow :: proc(g: ^Grid, row: i32) {
	for column: i32 = 0; column < g.numCols; column += 1 {
		g.data[row][column] = 0
	}
}

grid_moveRowDown :: proc(g: ^Grid, row: i32, numRows: i32) {
	for column: i32 = 0; column < g.numCols; column += 1 {
		g.data[row + numRows][column] = g.data[row][column]
		g.data[row][column] = 0
	}
}

grid_clearFullRows :: proc(g: ^Grid) -> i32 {
	completed: i32 = 0
	for row := g.numRows - 1; row >= 0; row -= 1 {
		if grid_isRowFull(g^, row) {
			grid_clearRow(g, row)
			completed += 1
		} else if completed > 0 {
			grid_moveRowDown(g, row, completed)
		}
	}
	return completed
}
