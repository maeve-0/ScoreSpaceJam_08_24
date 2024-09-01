extends ColorRect


func _ready() -> void:
	get_node('submit_button').connect('pressed', func():
		Scoreboard._upload_score(Globals.score)
		get_node('submit_button').disabled = true
	)

	get_node('exit_to_menu').connect('pressed', func():
		get_tree().change_scene_to_file('res://assets/scenes/main_menu.tscn')
	)


func _physics_process(delta: float) -> void:
	visible = Globals.player_health <= 0
