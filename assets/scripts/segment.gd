extends StaticBody3D


var appearance_speed = 60.0
var material: ShaderMaterial
var player: Player

@export var life_time := 4.0

var grow_amount := 0.0


const colors = [
	Color.ROYAL_BLUE,
	Color.MEDIUM_SEA_GREEN,
	Color.DARK_VIOLET,
]


func _ready():
	material = (get_node('mesh_instance') as MeshInstance3D).get_surface_override_material(0).duplicate()
	(get_node('mesh_instance') as MeshInstance3D).set_surface_override_material(0, material)
	grow_amount = -30.0
	material.set_shader_parameter('albedo', colors[randi() % len(colors)])


func _physics_process(delta: float) -> void:
	life_time -= delta
	material.set_shader_parameter('grow', grow_amount)
	if player:
		material.set_shader_parameter('player_z', player.global_position.z - global_position.z)
	if life_time <= 0.0:
		grow_amount -= delta * appearance_speed
		get_node('collision_shape').disabled = true
		if life_time <= -3.0:
			queue_free()
		return
	grow_amount = minf(grow_amount + delta * appearance_speed, 0.0)
