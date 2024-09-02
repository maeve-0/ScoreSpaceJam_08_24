class_name LevelGenerator
extends Node


var segments = [
	preload('res://assets/scenes/segments/segment_1.tscn'),
	preload('res://assets/scenes/segments/segment_2.tscn'),
	preload('res://assets/scenes/segments/segment_3.tscn'),
	preload('res://assets/scenes/segments/segment_4.tscn'),
	preload('res://assets/scenes/segments/segment_5.tscn'),
]


@export var first_segment_path: NodePath
@export var player_path: NodePath


var last_segment: Node3D

var appearance_distance := 10.0


@onready var player := get_node(player_path) as Player

var first_frame := true


func spawn_next(after: Node3D) -> void:
	var next_position := after.get_node('next_segment_position') as Node3D
	var next_instance = segments[randi() % len(segments)].instantiate()
	get_node('..').add_child(next_instance)
	next_instance.global_position = next_position.global_position
	next_instance.player = player
	last_segment = next_instance


func _ready() -> void:
	spawn_next.call_deferred(get_node(first_segment_path))


func _physics_process(delta: float) -> void:
	if first_frame:
		first_frame = false
		return

	if not is_instance_valid(last_segment):
		return

	if player.global_position.distance_squared_to(
		last_segment.get_node('next_segment_position').global_position
	) <= appearance_distance * appearance_distance:
		spawn_next(last_segment)
