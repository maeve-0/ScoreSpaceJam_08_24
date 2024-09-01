extends Node3D


@onready var player := get_node('player')
@onready var enviro := get_node('enviro')


const MAX_DISTANCE = 50.0


func _ready() -> void:
	Globals.score = 0

	LavaControl.state = LavaControl.State.NONE
	LavaControl.next_state = LavaControl.State.NONE

	LavaControl.next_state_progress = 0.0
	LavaControl.randomization_state = 0

	Globals.player_health = 1.0


func _physics_process(delta: float) -> void:
	if Globals.player_health > 0.0:
		Globals.score += delta * 5.0

	if player.global_position.z >= -MAX_DISTANCE:
		return

	player.global_position.z += MAX_DISTANCE
	if player.hand:
		player.hand.global_position.z += MAX_DISTANCE
	for child in enviro.get_children():
		if child is Node3D:
			child.global_position.z += MAX_DISTANCE
