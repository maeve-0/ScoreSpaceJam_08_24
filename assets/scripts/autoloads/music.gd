extends Node


@onready var tracks = {
	'menu': get_node('menu'),
	'gameplay': get_node('gameplay'),
}

var current_track: String


func play(track_name: String):
	if track_name == current_track:
		return
	for track in tracks.values():
		(track as AudioStreamPlayer).stop()
	tracks[track_name].play()
	current_track = track_name
