class_name Enemy
extends CharacterBody3D


const ATTACK_TIMEOUT = 1.0
const DEATH_DISTANCE = 2.0

@onready var body := get_node('body') as Node3D

var attack_timeout: float

var time := 0.0


func _ready():
	if randi() % 100 > (50 + int(Globals.player_max_distance/1000.0 * 50.0)):
		queue_free()

	attack_timeout = randf() * ATTACK_TIMEOUT

	add_collision_exception_with(Globals.player)


func _physics_process(delta: float) -> void:
	time += delta

	get_node('body/body').rotation.z = sin(time * 5.0) * 0.2
	get_node('body/body/body').rotation.z = cos(time * 2.0) * 0.1

	body.look_at(Globals.player.global_position, to_global(Vector3.UP) - global_position)
	body.rotation.x = 0.0

	attack_timeout -= delta
	if attack_timeout <= 0:
		attack()
		attack_timeout += ATTACK_TIMEOUT

	if Globals.player_attack_time > 0.2:
		if Globals.player.global_position.distance_squared_to(global_position) < DEATH_DISTANCE * DEATH_DISTANCE:
			Globals.score += 30
			queue_free()


func attack():
	var instance := preload('res://assets/scenes/slime_projectile.tscn').instantiate()
	instance.movement_vector = (Globals.player.global_position - get_node('body/body/body/head').global_position).normalized()
	get_node('..').add_child(instance)
	instance.global_position = get_node('body/body/body/head').global_position
