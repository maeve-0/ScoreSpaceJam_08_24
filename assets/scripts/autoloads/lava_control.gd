extends Node


enum State {
	NONE = 0,
	FLOOR = 1,
	LEFT_WALL = 2,
	RIGHT_WALL = 3,
	CEILING = 4,
}


const TIME_SCALE = 0.25


var state := State.NONE
var next_state := State.NONE


var next_state_progress := 0.0

var randomization_state := 0


func randomize_state():
	var next_state_array = [
		State.FLOOR,
		State.LEFT_WALL,
		State.RIGHT_WALL,
		State.CEILING,
	]
	next_state_array.erase(state)
	next_state = next_state_array[randi() % len(next_state_array)]


func _physics_process(delta: float) -> void:
	if Globals.player_health <= 0.0:
		return
	next_state_progress += delta * (TIME_SCALE+additional_time_scale())
	if randomization_state == 0:
		if next_state_progress >= 1.0:
			state = next_state
			next_state = State.NONE
			randomization_state = 1
	elif randomization_state == 1:
		if next_state_progress >= 2.5:
			randomize_state()
			next_state_progress = 0
			randomization_state = 0


func additional_time_scale() -> float:
	return minf(Globals.player_max_distance/2000.0 * 0.1, 0.2)
