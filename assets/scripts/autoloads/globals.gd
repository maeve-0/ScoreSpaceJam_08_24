extends Node


var menu_stars_time := 0.0
var menu_stars_rotation := Vector3.ZERO

var player: Player
var player_attack_time := 0.0
var player_max_distance := 0.0
var player_pain_time := 0.0


func _physics_process(delta: float) -> void:
	if player_attack_time > 0:
		player_attack_time -= delta


var player_health := 1.0:
	get():
		return player_health
	set(value):
		player_health = clampf(value, 0.0, 1.0)


var score := 0.0
