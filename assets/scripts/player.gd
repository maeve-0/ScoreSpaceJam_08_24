class_name Player
extends CharacterBody3D


@onready var camera := get_node('up_vector/y_rotation/camera') as Node3D
@onready var y_rotation := get_node('up_vector/y_rotation') as Node3D
@onready var up_vector := get_node('up_vector') as Node3D
@onready var actual_camera := get_node('camera') as Camera3D


const MAX_VERTICAL_CAMERA_ANGLE = deg_to_rad(90.0)
const MOUSE_SENSITIVITY = 0.001
const SPEED = 8.0
const JUMP_VELOCITY = 10.0
const MIN_HORIZONTAL_VELOCITY = 0.5
const MAX_HORIZONTAL_VELOCITY = 12.0
const HORIZONTAL_DAMP = 20.0
const HORIZONTAL_ACCELERATION = 10.0
const _90_DEGREES = deg_to_rad(90.0)


var hand: Hand


func _input(event: InputEvent):
	if Globals.player_health <= 0.0:
		return

	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		y_rotation.rotation.y -= event.screen_relative.x * MOUSE_SENSITIVITY
		camera.rotation.x = clampf(camera.rotation.x - event.screen_relative.y * MOUSE_SENSITIVITY, -MAX_VERTICAL_CAMERA_ANGLE, MAX_VERTICAL_CAMERA_ANGLE)


func _ready() -> void:
	up_direction = Vector3.UP


func _physics_process(delta: float) -> void:
	var player_input := collect_input()

	up_vector.look_at(global_position + Vector3(0.0, 0.0, -1.0), up_direction)
	if not is_on_floor():
		velocity += up_direction * get_gravity().y * delta

	if player_input['grapple'] and not hand:
		var grapple := preload('res://assets/scenes/hand.tscn').instantiate()
		grapple.player = self
		grapple.add_exception(self)
		get_node('..').add_child(grapple)
		grapple.global_position = global_position
		grapple.global_rotation = camera.global_rotation
		hand = grapple

	if player_input['jump'] and is_on_floor():
		velocity = up_direction * JUMP_VELOCITY

	var input_dir := player_input['movement'] as Vector2
	var direction := (
			input_dir.x * y_rotation.global_basis.x +
			input_dir.y * y_rotation.global_basis.z
	).normalized()
	if direction and (not hand or hand.state != hand.State.GRABBED) and Globals.player_health > 0.0:
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

	actual_camera.global_position = global_position

	var current_rot := Quaternion(actual_camera.global_basis)
	var target_rot := Quaternion(camera.global_basis)
	var smoothrot = current_rot.slerp(target_rot, 0.2)
	actual_camera.global_basis = Basis(smoothrot)

	move_and_slide()

	check_damage(delta)


func get_horizontal_movement_vector() -> Vector3:
	var horizontal_movement_vector := Vector3.ZERO
	for movement_vector_component in [
		up_vector.global_basis.x * (1.0 if Vector3(-1.0, 1.0, 0.0).angle_to(up_direction) < _90_DEGREES else -1.0),
		up_vector.global_basis.z
	]:
		horizontal_movement_vector += movement_vector_component
	return horizontal_movement_vector


const _45_DEGREES = deg_to_rad(45.0)

func check_damage(delta: float):
	if LavaControl.state == LavaControl.State.NONE:
		return
	var lava_normal: Vector3 = {
		LavaControl.State.FLOOR: Vector3.UP,
		LavaControl.State.LEFT_WALL: Vector3.RIGHT,
		LavaControl.State.RIGHT_WALL: Vector3.LEFT,
		LavaControl.State.CEILING: Vector3.DOWN,
	}[LavaControl.state]
	for index in range(get_slide_collision_count()):
		var collision := get_slide_collision(index)
		var normal := collision.get_normal()
		if normal.angle_to(lava_normal) <= _45_DEGREES:
			take_lava_damage(delta)
			break


func take_lava_damage(delta):
	Globals.player_health -= delta


func collect_input() -> Dictionary:
	if Globals.player_health <= 0.0:
		return {
			'movement': Vector2.ZERO,
			'jump': false,
			'grapple': false,
		}

	return {
		'movement': Input.get_vector('left', 'right', 'forward', 'backward'),
		'jump': Input.is_action_just_pressed('jump'),
		'grapple': Input.is_action_just_pressed('throw_grapple'),
	}
