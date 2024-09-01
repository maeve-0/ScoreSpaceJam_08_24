extends Label


const BASE_TEXT = 'FETCHING PLAYER POSITION'
var wait_time = 0.0


func _ready() -> void:
	Scoreboard._fetch_user_position_in_scoreboard()


func _physics_process(delta: float) -> void:
	wait_time += delta * 10.0
	text = BASE_TEXT
	for i in range(int(wait_time) % 4):
		text += '.'

	if not Scoreboard.fetching_player_position:
		Scoreboard.score_table_page_number = Scoreboard.player_position_page
		get_tree().change_scene_to_file('res://assets/scenes/scoreboard.tscn')
