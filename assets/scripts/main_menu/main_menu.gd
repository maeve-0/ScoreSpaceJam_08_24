extends Node3D


@onready var stars = get_node('stars') as Node3D


var time := 0.0


func _physics_process(delta: float) -> void:
	time += delta * 0.2
	stars.rotation += Vector3(sin(time)* 1.0, cos(time) * 0.5, sin(time) * 1.1) * delta * 0.2
