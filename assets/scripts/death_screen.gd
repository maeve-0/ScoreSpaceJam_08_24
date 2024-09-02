extends ColorRect


var was_visible := false


func _ready() -> void:
	get_node('submit_button').connect('pressed', func():
		Scoreboard._upload_score(Globals.score)
		get_node('submit_button').disabled = true
	)

	get_node('exit_to_menu').connect('pressed', func():
		get_tree().change_scene_to_file('res://assets/scenes/main_menu.tscn')
	)

	get_node('restart_button').connect('pressed', func():
		get_tree().reload_current_scene()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		Globals.player_health = 1.0
	)


func _input(event: InputEvent):
	if not visible:
		return
	if event is InputEventKey:
		if event.keycode == KEY_R:
			get_tree().reload_current_scene()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			Globals.player_health = 1.0


func _physics_process(delta: float) -> void:
	visible = Globals.player_health <= 0

	if visible:
		if not was_visible:
			Scoreboard._upload_score(Globals.score)
			was_visible = true
