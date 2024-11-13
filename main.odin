package game

import "core:fmt"
// import "core:mem"

import rl "vendor:raylib"

lastUpdateTime: f64

EventTrigger :: proc(interval: f64) -> bool {
	currentTime := rl.GetTime()
	if currentTime - lastUpdateTime >= interval {
		lastUpdateTime = currentTime
		return true
	}

	return false
}

main :: proc() {
	// import "core:mem" package to use the tracking allocator
	// when ODIN_DEBUG {
	// 	track: mem.Tracking_Allocator
	// 	mem.tracking_allocator_init(&track, context.allocator)
	// 	context.allocator = mem.tracking_allocator(&track)

	// 	defer {
	// 		if len(track.allocation_map) > 0 {
	// 			fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
	// 			for _, entry in track.allocation_map {
	// 				fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
	// 			}
	// 		}
	// 		if len(track.bad_free_array) > 0 {
	// 			fmt.eprintf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
	// 			for entry in track.bad_free_array {
	// 				fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
	// 			}
	// 		}
	// 		mem.tracking_allocator_destroy(&track)
	// 	}
	// }

	rl.InitWindow(500, 620, "Odin Tetris")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	font: rl.Font = rl.LoadFontEx("assets/font/monogram.ttf", 64, nil, 0)
	defer rl.UnloadFont(font)

	game := create_game()
	defer game->destroy()

	for !rl.WindowShouldClose() {
		rl.UpdateMusicStream(game.music)
		game->handleInput()
		if EventTrigger(0.2) {
			game->moveBlockDown()
		}
		rl.BeginDrawing()
		rl.ClearBackground(gridColorsVector[.darkBlue])
		rl.DrawTextEx(font, "Score", {356, 15}, 38, 2, rl.WHITE)
		rl.DrawTextEx(font, "Next", {370, 175}, 38, 2, rl.WHITE)
		if game.gameOver {
			rl.DrawTextEx(font, "GAME OVER", {320, 450}, 38, 2, rl.WHITE)
			rl.DrawTextEx(font, "PRESS SPACE", {350, 495}, 19, 2, rl.WHITE)
			rl.DrawTextEx(font, "TO RESTART", {355, 515}, 19, 2, rl.WHITE)
		}
		scoreText := fmt.ctprintf("%v", game.score)
		scoreTextSize := rl.MeasureTextEx(font, scoreText, 38, 2)
		rl.DrawRectangleRounded({320, 55, 170, 60}, 0.3, 6, gridColorsVector[.lightBlue])
		rl.DrawTextEx(font, scoreText, {320 + (170 - scoreTextSize.x) / 2, 65}, 38, 2, rl.WHITE)
		rl.DrawRectangleRounded({320, 215, 170, 180}, 0.3, 6, gridColorsVector[.lightBlue])
		game->draw()
		rl.EndDrawing()
	}
}
