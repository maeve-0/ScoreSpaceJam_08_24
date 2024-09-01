extends Control


@onready var label := get_node('label')
@onready var input := get_node('custom_line_edit') as LineEdit
@onready var accept_button := get_node('custom_button') as Button


func _ready():
	input.text = Scoreboard.player_name
	accept_button.connect('pressed', func():
		Scoreboard._change_player_name(input.text)
	)


func _physics_process(delta: float) -> void:
	accept_button.disabled = Scoreboard.setting_name
	if input.text == Scoreboard.player_name:
		label.text = 'PLAYER NAME'
	else:
		label.text = 'PLAYER NAME*'
