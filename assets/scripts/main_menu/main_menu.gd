extends Node3D


@onready var stars = get_node('stars') as Node3D


func _ready() -> void:
	stars.rotation = Globals.menu_stars_rotation
	Music.play('menu')


func _physics_process(delta: float) -> void:
	Globals.menu_stars_time += delta * 0.2
	Globals.menu_stars_rotation += Vector3(sin(Globals.menu_stars_time)* 1.0, cos(Globals.menu_stars_time) * 0.5, sin(Globals.menu_stars_time) * 1.1) * delta * 0.2
	stars.rotation = Globals.menu_stars_rotation
