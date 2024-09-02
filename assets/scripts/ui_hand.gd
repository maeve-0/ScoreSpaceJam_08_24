extends TextureRect


func on_resize():
	size.y = get_viewport_rect().size.y
	size.x = size.y / 9.0 * 16.0
	position.y = get_viewport_rect().size.y - size.y
	position.x = 0.0


func _ready():
	on_resize()
	get_viewport().connect('size_changed', on_resize)


func _physics_process(delta: float) -> void:
	visible = Globals.player_health > 0.0 and Globals.player.hand == null
