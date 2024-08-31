class_name Hand
extends RayCast3D


@onready var sprites := get_node('sprites') as Node3D


const SPEED = 20.0
const GRAPPLING_ACCELERATION = 30.0
var first_grab := true


enum State {
	REACHING,
	GRABBED,
	BOUNCED,
}


var lifetime = 0.5


var state := State.REACHING
var player: Player


func process_reaching(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0.0:
		state = State.BOUNCED
		return
	if is_colliding():
		check_collision()
		global_position = get_collision_point()
		return
	global_position -= global_transform.basis.z * delta * SPEED


func process_bounced(delta: float) -> void:
	global_position += (player.global_position - global_position).normalized() * delta * SPEED
	if global_position.distance_to(player.global_position) < 1.0:
		queue_free()
		player.hand = null


func process_grabbed(delta: float) -> void:
	player.velocity += (global_position - player.global_position).normalized() * delta * GRAPPLING_ACCELERATION
	player.up_direction = get_collision_normal()
	if first_grab:
		first_grab = false
		return
	if player.is_on_floor():
		queue_free()
		player.hand = null


func check_collision():
	var collider := get_collider()
	if collider is Grabbable:
		state = State.GRABBED
	else:
		state = State.BOUNCED


func _physics_process(delta: float) -> void:
	match state:
		State.REACHING:
			process_reaching(delta)
		State.BOUNCED:
			process_bounced(delta)
		State.GRABBED:
			process_grabbed(delta)

	sprites.look_at(player.global_position - player.camera.global_basis.y * 0.1, player.camera.global_basis.y)
	sprites.scale.z = -sprites.global_position.distance_to(player.global_position) * 0.5/0.08
