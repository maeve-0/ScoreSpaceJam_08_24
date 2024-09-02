extends Node3D


@onready var player := get_node('player')
@onready var enviro := get_node('enviro')

var distances_run := 0

const MAX_DISTANCE = 50.0


func _ready() -> void:
	Globals.score = 0

	LavaControl.state = LavaControl.State.NONE
	LavaControl.next_state = LavaControl.State.NONE

	LavaControl.next_state_progress = 0.0
	LavaControl.randomization_state = 0

	Globals.player_health = 1.0
	distances_run = 0
	Globals.player_max_distance = 0.0

	Music.play('gameplay')


func _physics_process(delta: float) -> void:
	if Globals.player_health > 0.0:
		var player_distance_now = distances_run * MAX_DISTANCE - player.global_position.z - 2.0
		if player_distance_now > Globals.player_max_distance:
			Globals.score += (player_distance_now - Globals.player_max_distance)
			Globals.player_max_distance = player_distance_now

	if player.global_position.z >= -MAX_DISTANCE:
		return

	player.global_position.z += MAX_DISTANCE
	distances_run += 1
	if player.hand:
		player.hand.global_position.z += MAX_DISTANCE
	for child in enviro.get_children():
		if child is Node3D:
			child.global_position.z += MAX_DISTANCE
