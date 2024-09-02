extends Node


@onready var pain_sounds := [
	get_node('pain1'),
	get_node('pain2'),
	get_node('pain3'),
	get_node('pain4'),
]

var current_pain_sound = null


func _ready():
	for sound in pain_sounds:
		(sound as AudioStreamPlayer).connect('finished', func():
			current_pain_sound = null
		)


func play_pain():
	if Globals.player_health <= 0:
		return
	if current_pain_sound:
		return
	current_pain_sound = pain_sounds[randi() % len(pain_sounds)]
	current_pain_sound.play()


func play_death():
	get_node('death').play()
