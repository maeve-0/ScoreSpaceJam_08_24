extends Node


const CONFIG_FILE_PATH = 'user://LootLocker.data'

const PAGE_SIZE = 11


# Use this game API key if you want to test it with a functioning leaderboard
# "987dbd0b9e5eb3749072acc47a210996eea9feb0"
var game_API_key = "dev_802fe359e7c64fd1861fdeedc02cc7d7"
var development_mode = true
var leaderboard_key = "scoreboard"
var session_token = ""

# HTTP Request node can only handle one call per node
var auth_http = HTTPRequest.new()
var leaderboard_http = HTTPRequest.new()
var submit_score_http = HTTPRequest.new()

var set_name_http = HTTPRequest.new()
var get_name_http = HTTPRequest.new()


var player_name := ''
var synced := false
var setting_name := false
var failed := false

var fetching_score_table := false
var failed_to_fetch_score_table := false
var score_table_page = []
var score_table_page_number := 0
var total_scores := 0

var uploading_score := false


func _ready():
	_authentication_request()


func _authentication_request():
	# Check if a player session exists
	var player_session_exists = false
	var player_identifier : String
	var file = ConfigFile.new()
	file.load(CONFIG_FILE_PATH)
	player_identifier = file.get_value('data', 'player_id', '')
	#player_identifier = ''
 
	if player_identifier != null and player_identifier.length() > 1:
		print("player session exists, id="+player_identifier)
		player_session_exists = true
		
	## Convert data to json string:
	var data = { "game_key": game_API_key, "game_version": "0.0.0.1", "development_mode": development_mode }
	
	# If a player session already exists, send with the player identifier
	if player_session_exists:
		data = { "game_key": game_API_key, "player_identifier":player_identifier, "game_version": "0.0.0.1", "development_mode": development_mode }
	
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	
	# Create a HTTPRequest node for authentication
	auth_http = HTTPRequest.new()
	add_child(auth_http)
	auth_http.request_completed.connect(_on_authentication_request_completed)
	# Send request
	auth_http.request("https://api.lootlocker.io/game/v2/session/guest", headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	# Print what we're sending, for debugging purposes:
	print(data)


func _on_authentication_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())

	# Save the player_identifier to file
	var data = json.get_data()
	print(data)
	if not data:
		failed = true
		return
	var file := ConfigFile.new()
	file.set_value('data', 'player_id', data.player_identifier)
	file.save(CONFIG_FILE_PATH)

	# Save session_token to memory
	session_token = data.session_token
	
	# Clear node
	auth_http.queue_free()

	_get_player_name()
	
	#_upload_score(randi() % 200)


func _get_leaderboards():
	fetching_score_table = true
	print("Getting leaderboards")
	var url = "https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/list?after="+str(PAGE_SIZE * score_table_page_number)+"&count="+str(PAGE_SIZE)
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	
	# Create a request node for getting the highscore
	leaderboard_http = HTTPRequest.new()
	add_child(leaderboard_http)
	leaderboard_http.request_completed.connect(_on_leaderboard_request_completed)
	
	# Send request
	leaderboard_http.request(url, headers, HTTPClient.METHOD_GET, "")

func _on_leaderboard_request_completed(result, response_code, headers, body):
	fetching_score_table = false
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())

	# Print data
	var data = json.get_data()
	print(data)

	if not data:
		failed_to_fetch_score_table = true
		score_table_page = []
		return

	failed_to_fetch_score_table = false

	total_scores = data['pagination']['total']
	print(total_scores)

	score_table_page = []
	for item in data.items if data and data.items != null else []:
		score_table_page.append({
			'player_name': item['player']['name'] if item['player']['name'] and item['player']['name'] != '' else item['player']['public_uid'],
			'rank': item['rank'],
			'score': item['score'],
		})

	# Clear node
	leaderboard_http.queue_free()


func _upload_score(score: int):
	var data = { "score": str(score) }
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	submit_score_http = HTTPRequest.new()
	add_child(submit_score_http)
	submit_score_http.request_completed.connect(_on_upload_score_request_completed)
	# Send request
	submit_score_http.request("https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/submit", headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	# Print what we're sending, for debugging purposes:
	print(data)
	uploading_score = true

func _change_player_name(new_name: String):
	setting_name = true
	print("Changing player name")
	
	var data = { "name": str(new_name) }
	var url =  "https://api.lootlocker.io/game/player/name"
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	
	# Create a request node for getting the highscore
	set_name_http = HTTPRequest.new()
	add_child(set_name_http)
	set_name_http.request_completed.connect(_on_player_set_name_request_completed)
	# Send request
	set_name_http.request(url, headers, HTTPClient.METHOD_PATCH, JSON.stringify(data))

	player_name = new_name

func _on_player_set_name_request_completed(result, response_code, headers, body):
	setting_name = false
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Print data
	print(json.get_data())
	set_name_http.queue_free()

func _get_player_name():
	print("Getting player name")
	var url = "https://api.lootlocker.io/game/player/name"
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]

	# Create a request node for getting the highscore
	get_name_http = HTTPRequest.new()
	add_child(get_name_http)
	get_name_http.request_completed.connect(_on_player_get_name_request_completed)
	# Send request
	get_name_http.request(url, headers, HTTPClient.METHOD_GET, "")

func _on_player_get_name_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	var data = json.get_data()
	
	if not data:
		failed = true
		return
	
	# Print data
	print(data)
	# Print player name
	player_name = data.name

	synced = true

func _on_upload_score_request_completed(result, response_code, headers, body) :
	uploading_score = false
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Print data
	print(json.get_data())
	
	# Clear node
	submit_score_http.queue_free()
