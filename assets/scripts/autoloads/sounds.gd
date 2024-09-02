extends Node


@onready var pain_sounds := [
	get_node('pain1'),
	get_node('pain2'),
	get_node('pain3'),
	get_node('pain4'),
]

var current_pain_sound = null


func play_pain():
	if Globals.player_health <= 0:
		return
	if current_pain_sound:
		return
	current_pain_sound = pain_sounds[randi() % len(pain_sounds)]
	current_pain_sound.play()


@onready var woosh_sounds := [
	get_node('woosh1'),
	get_node('woosh2'),
	get_node('woosh3'),
]


func play_woosh():
	if Globals.player_health <= 0:
		return
	woosh_sounds[randi() % len(woosh_sounds)].play()


func _ready():
	for sound in pain_sounds:
		(sound as AudioStreamPlayer).connect('finished', func():
			current_pain_sound = null
		)


func play_death():
	get_node('death').play()


func play_slime_kill():
	get_node('slime_kill').play()


func play_cut():
	get_node('cut').play()
