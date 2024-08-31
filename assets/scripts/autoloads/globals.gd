extends Node


var player_health := 1.0:
	get():
		return player_health
	set(value):
		player_health = clampf(value, 0.0, 1.0)
