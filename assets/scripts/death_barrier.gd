extends Area3D


func on_body_enter(body):
	if body is Player:
		Globals.player_health = 0


func _ready() -> void:
	connect('body_entered', on_body_enter)
