class_name Grabbable
extends Area3D


const _45_DEGREES = deg_to_rad(45.0)


@onready var collision_shape := get_node('collision_shape') as CollisionShape3D
@onready var particle_emitter := get_node('particle_emitter') as CPUParticles3D

@export var size := Vector2(1.0, 1.0)


func _ready():
	generate()


func generate():
	collision_shape.shape = collision_shape.shape.duplicate()
	(collision_shape.shape as BoxShape3D).size = Vector3(size.x, 0.2, size.y)
	particle_emitter.emission_box_extents = Vector3(size.x, 0.0, size.y) / 2.0
	particle_emitter.amount = size.x * size.y


func _physics_process(delta: float) -> void:
	if LavaControl.state == LavaControl.State.NONE:
		collision_shape.disabled = false
		particle_emitter.emitting = true
		return

	if get_tree().current_scene.scene_file_path != 'res://assets/scenes/main_scene.tscn':
		return

	var lava_normal: Vector3 = {
		LavaControl.State.FLOOR: Vector3.UP,
		LavaControl.State.LEFT_WALL: Vector3.RIGHT,
		LavaControl.State.RIGHT_WALL: Vector3.LEFT,
		LavaControl.State.CEILING: Vector3.DOWN,
	}[LavaControl.state]

	var disabled := lava_normal.angle_to(global_transform.basis.y) < _45_DEGREES
	collision_shape.disabled = disabled
	particle_emitter.emitting = not disabled
