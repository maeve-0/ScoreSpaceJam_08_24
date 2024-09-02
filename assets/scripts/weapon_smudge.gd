extends 'res://assets/scripts/weapon.gd'


func _ready() -> void:
	super._ready()
	modulate.a = 0.0


func _physics_process(delta: float) -> void:
	modulate.a = maxf(sin(Globals.player_attack_time * PI * 1.0), 0.0)
