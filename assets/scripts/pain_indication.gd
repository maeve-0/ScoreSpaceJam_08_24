extends ColorRect


func _physics_process(delta: float) -> void:
	Globals.player_pain_time -= delta
	visible = Globals.player_health > 0 and Globals.player_pain_time > 0
