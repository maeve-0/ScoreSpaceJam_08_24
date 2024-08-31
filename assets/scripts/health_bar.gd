extends ColorRect


@onready var filling := get_node('filling') as ColorRect


func _physics_process(delta: float) -> void:
	var health := clampf(Globals.player_health, 0.0, 1.0)
	filling.size = Vector2(
		size.x * health,
		size.y
	)
	filling.position = Vector2(
		(size.x - filling.size.x) / 2.0,
		0.0
	)
