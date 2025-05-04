class_name SaverLoader
extends Node

@onready var volume_slider_master: HSlider = $"../Menu/AudioSettings/MarginContainer/TextureRect/VBoxContainer/VolumeSlider"
@onready var volume_slider_music: HSlider = $"../Menu/AudioSettings/MarginContainer/TextureRect/VBoxContainer/VolumeSlider2"
@onready var volume_slider_sfx: HSlider = $"../Menu/AudioSettings/MarginContainer/TextureRect/VBoxContainer/VolumeSlider3"



#@onready var music_volume: HSlider = $"../settings/MarginContainer/TextureRect/VBoxContainer/volume_slider"
#@onready var sfx_volume: HSlider = $"../settings/MarginContainer/TextureRect/VBoxContainer/volume_slider2"
func _ready() -> void:
	EventHandler.save_progress.connect(save_game)

func save_game():
	var saved_game: SavedGame = SavedGame.new()
	saved_game.master_value = volume_slider_master.value
	saved_game.music_value = volume_slider_music.value
	saved_game.sfx_value = volume_slider_sfx.value
#	saved_game.current_health= GlobalVar.current_health
#	saved_game.current_level = GlobalVar.current_level
	ResourceSaver.save(saved_game, "user://savegame.tres")

func load_game():
	var path = "user://savegame.tres"
	if FileAccess.file_exists(path):
		var saved_game:SavedGame = load(path)
		if saved_game !=null:
			volume_slider_master.value = saved_game.master_value
			volume_slider_music.value = saved_game.music_value
			volume_slider_sfx.value = saved_game.sfx_value
			
#			GlobalVar.current_health = saved_game.current_health
#			GlobalVar.current_level = saved_game.current_level
