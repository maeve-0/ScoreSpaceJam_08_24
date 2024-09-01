extends Node


var menu_stars_time := 0.0
var menu_stars_rotation := Vector3.ZERO


var player_health := 1.0:
	get():
		return player_health
	set(value):
		player_health = clampf(value, 0.0, 1.0)


var score := 0.0
