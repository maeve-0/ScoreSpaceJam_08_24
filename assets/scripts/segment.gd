extends StaticBody3D


var appearance_speed = 60.0
var material: StandardMaterial3D

@export var life_time := 4.0


func _ready():
	material = (get_node('mesh_instance') as MeshInstance3D).get_surface_override_material(0).duplicate()
	(get_node('mesh_instance') as MeshInstance3D).set_surface_override_material(0, material)
	material.grow_amount = -30.0


func _physics_process(delta: float) -> void:
	life_time -= delta
	if life_time <= 0.0:
		material.grow_amount -= delta * appearance_speed
		get_node('collision_shape').disabled = true
		if life_time <= -3.0:
			queue_free()
		return
	material.grow_amount = minf(material.grow_amount + delta * appearance_speed, 0.0)
