class_name Hand
extends RayCast3D


@onready var sprites := get_node('sprites') as Node3D


const SPEED = 35.0
const GRAPPLING_ACCELERATION = 15.0
var first_grab := true


enum State {
	REACHING,
	GRABBED,
	BOUNCED,
}


var lifetime = 0.5


var state := State.REACHING
var player: Player

var collider: Node3D


func process_reaching(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0.0:
		state = State.BOUNCED
		lifetime = 0.5
		return
	if is_colliding():
		check_collision()
		global_position = get_collision_point()
		return
	global_position -= global_transform.basis.z * delta * SPEED


func process_bounced(delta: float) -> void:
	lifetime -= delta
	global_position += (player.global_position - global_position).normalized() * delta * SPEED
	if global_position.distance_to(player.global_position) < 1.0 or lifetime <= 0.0:
		queue_free()
		player.hand = null


func process_grabbed(delta: float) -> void:
	lifetime -= delta
	player.velocity = (global_position - player.global_position).normalized() * GRAPPLING_ACCELERATION
	player.up_direction = collider.global_basis.y
	if first_grab:
		first_grab = false
		return
	if global_position.distance_to(player.global_position) < 1.0 or lifetime <= 0:
		if global_position.distance_to(player.global_position) < 1.0:
			player.velocity *= 0.5
		queue_free()
		player.hand = null


func check_collision():
	collider = get_collider()
	if collider is Grabbable:
		lifetime = 1.0
		state = State.GRABBED
		player.update_rotation_for_grab(collider.global_basis.y)
	elif collider is SlimeProjectile or collider is Enemy:
		return
	else:
		state = State.BOUNCED
		lifetime = 0.5


func _physics_process(delta: float) -> void:
	match state:
		State.REACHING:
			process_reaching(delta)
		State.BOUNCED:
			process_bounced(delta)
		State.GRABBED:
			process_grabbed(delta)

	sprites.look_at(player.global_position - player.camera.global_basis.y * 0.2  - player.camera.global_basis.x * 0.15, player.camera.global_basis.y)
	sprites.scale.z = -sprites.global_position.distance_to(player.global_position) * 0.5/0.08
