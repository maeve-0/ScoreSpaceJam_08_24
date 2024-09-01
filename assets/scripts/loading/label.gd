extends Label


const BASE_TEXT = 'SYNCHRONIZING WITH LOOTLOCKER'
const RESET_GAME_TEXT = 'SYNCHRONIZATION FAILED\nCHECK YOUR INTERNET CONNECTION AND RESTART THE GAME'
var wait_time = 0.0


func _physics_process(delta: float) -> void:
	wait_time += delta * 10.0
	text = BASE_TEXT
	for i in range(int(wait_time) % 4):
		text += '.'

	if Scoreboard.failed:
		text = RESET_GAME_TEXT

	if Scoreboard.synced:
		get_tree().change_scene_to_file('res://assets/scenes/main_menu.tscn')
