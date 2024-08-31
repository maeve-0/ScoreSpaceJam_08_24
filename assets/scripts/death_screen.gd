extends ColorRect


func _physics_process(delta: float) -> void:
	visible = Globals.player_health <= 0
