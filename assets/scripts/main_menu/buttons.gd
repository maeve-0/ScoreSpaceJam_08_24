extends Control


@onready var button_start := get_node('start_button') as Button
@onready var button_exit := get_node('exit_button') as Button


func _ready() -> void:
	button_start.connect('pressed', func():
		get_tree().change_scene_to_file('res://assets/scenes/main_scene.tscn')
	)

	if OS.get_name() == 'Web':
		button_exit.visible = false
	else:
		button_exit.connect('pressed', func():
			get_tree().quit()
		)
