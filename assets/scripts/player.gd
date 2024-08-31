class_name Player
extends CharacterBody3D


@onready var camera := get_node('up_vector/y_rotation/camera') as Camera3D
@onready var y_rotation := get_node('up_vector/y_rotation') as Node3D
@onready var up_vector := get_node('up_vector') as Node3D


const MAX_VERTICAL_CAMERA_ANGLE = deg_to_rad(90.0)
const MOUSE_SENSITIVITY = 0.001
const SPEED = 4.0
const JUMP_VELOCITY = 10.0
const MIN_HORIZONTAL_VELOCITY = 0.5
const MAX_HORIZONTAL_VELOCITY = 4.0
const HORIZONTAL_DAMP = 20.0
const HORIZONTAL_ACCELERATION = 10.0
const _90_DEGREES = deg_to_rad(90.0)


var hand: Hand


func _input(event: InputEvent):
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		y_rotation.rotation.y -= event.screen_relative.x * MOUSE_SENSITIVITY
		camera.rotation.x = clampf(camera.rotation.x - event.screen_relative.y * MOUSE_SENSITIVITY, -MAX_VERTICAL_CAMERA_ANGLE, MAX_VERTICAL_CAMERA_ANGLE)


func _ready() -> void:
	up_direction = Vector3.UP


func _physics_process(delta: float) -> void:
	up_vector.look_at(global_position + Vector3(0.0, 0.0, -1.0), up_direction)
	if not is_on_floor():
		velocity += up_direction * get_gravity().y * delta

	if Input.is_action_just_pressed('throw_grapple') and not hand:
		var grapple := preload('res://assets/scenes/hand.tscn').instantiate()
		grapple.player = self
		grapple.add_exception(self)
		get_node('..').add_child(grapple)
		grapple.global_position = global_position
		grapple.global_rotation = camera.global_rotation
		hand = grapple

	if Input.is_action_just_pressed('ui_accept') and is_on_floor():
		velocity = up_direction * JUMP_VELOCITY

	var input_dir := Input.get_vector('left', 'right', 'forward', 'backward')
	var direction := (
			input_dir.x * y_rotation.global_basis.x +
			input_dir.y * y_rotation.global_basis.z
	).normalized()
	if direction:
		velocity += direction * SPEED * delta * HORIZONTAL_ACCELERATION
		var horizontal_velicity := velocity * get_horizontal_movement_vector()
		if horizontal_velicity.length_squared() > MAX_HORIZONTAL_VELOCITY * MAX_HORIZONTAL_VELOCITY:
			velocity -= horizontal_velicity
			velocity += horizontal_velicity.normalized() * MAX_HORIZONTAL_VELOCITY
	elif not hand or hand.state != hand.State.GRABBED:
		var horizontal_velocity := velocity * get_horizontal_movement_vector()
		if horizontal_velocity.length_squared() < MIN_HORIZONTAL_VELOCITY:
			velocity -= horizontal_velocity
		else:
			velocity -= horizontal_velocity.normalized() * delta * HORIZONTAL_DAMP

	move_and_slide()


func get_horizontal_movement_vector() -> Vector3:
	var horizontal_movement_vector := Vector3.ZERO
	for movement_vector_component in [
		up_vector.global_basis.x * (1.0 if Vector3(-1.0, 1.0, 0.0).angle_to(up_direction) < _90_DEGREES else -1.0),
		up_vector.global_basis.z
	]:
		horizontal_movement_vector += movement_vector_component
	return horizontal_movement_vector
