extends Label


@export var prefix := ''
@export var final := false


func _physics_process(delta: float) -> void:
	visible = final or Globals.player_health > 0.0
	text = prefix + str(floor(Globals.score))
