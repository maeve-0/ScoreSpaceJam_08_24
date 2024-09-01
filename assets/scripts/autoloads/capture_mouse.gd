extends Node


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if get_tree().current_scene.scene_file_path != 'res://assets/scenes/main_scene.tscn':
			return
		if event.pressed:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
