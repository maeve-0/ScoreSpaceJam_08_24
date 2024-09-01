extends Control


@onready var button_back := get_node('button_back') as Button
@onready var failed_to_fetch_label := get_node('failed_to_fetch_label')
@onready var fetching_label := get_node('fetching_label')
@onready var scores_list := get_node('list_container/v_box_container')
@onready var scores_container := get_node('list_container')

@onready var button_next := get_node('button_next') as Button
@onready var button_previous := get_node('button_previous') as Button


var changing_page := true


func _ready() -> void:
	button_back.connect('pressed', func():
		get_tree().change_scene_to_file('res://assets/scenes/main_menu.tscn')
	)

	Scoreboard.score_table_page = 0
	Scoreboard._get_leaderboards()

	button_previous.connect('pressed', func():
		Scoreboard.score_table_page_number -= 1
		Scoreboard._get_leaderboards()
		changing_page = true
		scores_container.hide()
		fetching_label.show()
	)

	button_next.connect('pressed', func():
		Scoreboard.score_table_page_number += 1
		Scoreboard._get_leaderboards()
		changing_page = true
		scores_container.hide()
		fetching_label.show()
	)


func _physics_process(delta: float) -> void:
	button_next.disabled = changing_page or ((Scoreboard.score_table_page_number + 1) * Scoreboard.PAGE_SIZE >= Scoreboard.total_scores)
	button_previous.disabled = changing_page or (Scoreboard.score_table_page_number - 1 < 0)

	if not changing_page:
		return

	if Scoreboard.fetching_score_table:
		return

	if Scoreboard.failed_to_fetch_score_table:
		fetching_label.hide()
		failed_to_fetch_label.show()
		pass

	fetching_label.hide()
	failed_to_fetch_label.hide()
	for child in scores_list.get_children():
		child.queue_free()
	for item in Scoreboard.score_table_page:
		var instance = preload('res://assets/scenes/ui/scoreboard_entry.tscn').instantiate()
		instance.get_node('name_label').text = '{rank}. {player_name}'.format(item)
		instance.get_node('score_label').text = '{score}'.format(item)
		scores_list.add_child(instance)
	print(Scoreboard.score_table_page)

	changing_page = false

	scores_container.show()
