class_name SlimeProjectile
extends Area3D


const SPEED = 20.0

var movement_vector: Vector3


func on_body_enter(body):
	if body is Enemy:
		return
	if body is Player:
		Globals.player_health -= 0.2
		body.healing_timeout = 3.0
	queue_free()


func _ready() -> void:
	connect('body_entered', on_body_enter)


func _physics_process(delta: float) -> void:
	position += movement_vector * SPEED * delta
