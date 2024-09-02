extends ColorRect


func _input(event: InputEvent):
	if event is InputEventKey:
		if not event.pressed:
			return
		if event.keycode != KEY_TAB:
			return
		get_tree().paused = not get_tree().paused
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if get_tree().paused else Input.MOUSE_MODE_CAPTURED


func _ready() -> void:
	get_node('resume_button').connect('pressed', func():
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	)


	get_node('exit_button').connect('pressed', func():
		get_tree().paused = false
		get_tree().change_scene_to_file('res://assets/scenes/main_menu.tscn')
	)


func _physics_process(delta: float) -> void:
	visible = get_tree().paused
