class_name Grabbable
extends Area3D


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
