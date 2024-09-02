class_name SlimeProjectile
extends Area3D


const SPEED = 20.0

var movement_vector: Vector3

var lifetime := 15.0


func on_body_enter(body):
	if body is Enemy:
		return
	if body is Player:
		Globals.player_health -= 0.2
		body.healing_timeout = 3.0
		Sounds.play_pain()
		Globals.player_pain_time = 0.2
	queue_free()


func _ready() -> void:
	connect('body_entered', on_body_enter)


func _physics_process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()
	position += movement_vector * SPEED * delta
