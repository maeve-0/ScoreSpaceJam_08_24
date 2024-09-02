extends VBoxContainer


@onready var master_slider := get_node('slider_master/h_slider') as HSlider
@onready var sfx_slider := get_node('slider_sfx/h_slider') as HSlider
@onready var music_slider := get_node('slider_music/h_slider') as HSlider


func on_master_slider_change(first_time_adjust = null):
	var sfx_index := AudioServer.get_bus_index('Master')
	AudioServer.set_bus_mute(sfx_index, master_slider.value == -42.0)
	AudioServer.set_bus_volume_db(sfx_index, master_slider.value)
	if first_time_adjust == null:
		return
	save()


func on_sfx_slider_change(first_time_adjust = null):
	var sfx_index := AudioServer.get_bus_index('sfx')
	AudioServer.set_bus_mute(sfx_index, sfx_slider.value == -42.0)
	AudioServer.set_bus_volume_db(sfx_index, sfx_slider.value)
	if first_time_adjust == null:
		return

	Sounds.play_slime_kill()
	save()


func on_music_slider_change(first_time_adjust = null):
	var sfx_index := AudioServer.get_bus_index('music')
	AudioServer.set_bus_mute(sfx_index, music_slider.value == -42.0)
	AudioServer.set_bus_volume_db(sfx_index, music_slider.value)
	if first_time_adjust == null:
		return
	save()


func _ready() -> void:
	var config_file := ConfigFile.new()
	config_file.load(Scoreboard.CONFIG_FILE_PATH)
	master_slider.value = config_file.get_value('audio', 'master_volume', 0.0)
	sfx_slider.value = config_file.get_value('audio', 'sfx_volume', 0.0)
	music_slider.value = config_file.get_value('audio', 'music_volume', 0.0)
	on_master_slider_change()
	on_sfx_slider_change()
	on_music_slider_change()

	master_slider.connect('drag_ended', on_master_slider_change)
	sfx_slider.connect('drag_ended', on_sfx_slider_change)
	music_slider.connect('drag_ended', on_music_slider_change)


func save():
	var config_file := ConfigFile.new()
	config_file.load(Scoreboard.CONFIG_FILE_PATH)
	config_file.set_value('audio', 'master_volume', master_slider.value)
	config_file.set_value('audio', 'sfx_volume', sfx_slider.value)
	config_file.set_value('audio', 'music_volume', music_slider.value)
	config_file.save(Scoreboard.CONFIG_FILE_PATH)
