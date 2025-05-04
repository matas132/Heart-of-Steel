extends Node

@onready var start_game: Button = $Menu/TitleScreen/MarginContainer/VBoxContainer/StartGame
@onready var settings: Button = $Menu/TitleScreen/MarginContainer/VBoxContainer/Settings
@onready var quit: Button = $Menu/TitleScreen/MarginContainer/VBoxContainer/Quit
@onready var exit_audio_settings : Button = $Menu/AudioSettings/MarginContainer/TextureRect/VBoxContainer/ExitSettings
@onready var exit_control_settings : Button = $Menu/Controls/PanelContainer/MarginContainer/TextureRect/VBoxContainer/HBoxContainer/Controls_Exit

@onready var about: Button = $Menu/TitleScreen/MarginContainer/VBoxContainer/About

#@onready var game: Game = $Game
var game : Game

const HUD = preload("res://Scenes/UI/HUD/hud.tscn")


#Pause menu is also handled in the scene manager
@onready var pause_to_controls: Button = $Menu/PauseMenu/MarginContainer/TextureRect/VBoxContainer/Controls
@onready var pause_audio_settings: Button = $Menu/PauseMenu/MarginContainer/TextureRect/VBoxContainer/AudioSettings
@onready var pause_exit: Button = $Menu/PauseMenu/MarginContainer/TextureRect/VBoxContainer/ExitPausedMenu
@onready var pause_to_title: Button = $Menu/PauseMenu/MarginContainer/TextureRect/VBoxContainer/ToTitle

#Settings menu is also handled in the scene manage
@onready var settings_audio_setting: Button = $Menu/SettingsMenu/MarginContainer/TextureRect/VBoxContainer/AudioSettings
@onready var settings_controls_setting: Button = $Menu/SettingsMenu/MarginContainer/TextureRect/VBoxContainer/Controls
@onready var settings_to_title: Button = $Menu/SettingsMenu/MarginContainer/TextureRect/VBoxContainer/ToTitle

#MENU
@onready var audio_settings: Control = $Menu/AudioSettings
@onready var pause_menu: Control = $Menu/PauseMenu
@onready var settings_menu: Control = $Menu/SettingsMenu
@onready var controls: Control = $Menu/Controls

@onready var title_screen: Control = $Menu/TitleScreen


@onready var saver_loader: SaverLoader = $SaverLoader

const TITLE_SCREEN = preload("res://Scenes/UI/Menus/TitleScreen/title_screen.tscn")

var player_in_pause_menu := false
var player_in_settings_menu := false

func _ready():
	saver_loader.load_game()
	_load_main_menu()
	#AudioHandler.play_music(AudioHandler.MUSIC.OPENING)
	AudioHandler.lerp_from_none_to_max(AudioHandler.title)
	EventHandler.show_title_screen.connect(on_show_title_screen)
	
	EventHandler.press_pause.connect(_on_pause_press)
	
	EventHandler.to_title_quit.connect(_on_pause_to_title_pressed)


func _load_main_menu():
	start_game.pressed.connect(_on_start_game_pressed)
	
	quit.pressed.connect(_on_quit_pressed)
	about.pressed.connect(_on_about_pressed)
	
	# Exit Buttons
	exit_audio_settings.pressed.connect(_on_exit_audio_settings_pressed)
	exit_control_settings.pressed.connect(_on_exit_control_settings_pressed)
	
	#Pause menu
	pause_to_controls.pressed.connect(_on_pause_to_controls_pressed)
	pause_audio_settings.pressed.connect(_on_pause_audio_settings_pressed) # sets it so pause menu's audio settings button opens audio settings
	pause_exit.pressed.connect(_on_pause_exit_pressed)
	pause_to_title.pressed.connect(_on_pause_to_title_pressed)
	
	#Settings menu
	settings.pressed.connect(_on_settings_pressed)
	settings_audio_setting.pressed.connect(_on_settings_audio_settings_pressed)
	settings_controls_setting.pressed.connect(_on_settings_control_settings_pressed)
	settings_to_title.pressed.connect(_on_settings_to_title_pressed)

func set_game_paused(paused: bool):
	get_tree().paused = paused

func on_show_title_screen()->void:
	title_screen.visible = true
	#AudioHandler.play_music(AudioHandler.MUSIC.OPENING)

# Title screen functions
func _on_start_game_pressed():
	saver_loader.load_game() # TODO bring this back

	title_screen.visible = false
	AudioHandler.lerp_to_none(AudioHandler.title)
	
	game = GAME.instantiate()
	add_child(game)
	game.game_start()
	

func _on_quit_pressed():
	saver_loader.save_game()
	get_tree().quit()

func _on_about_pressed():
	print("about pressed")

# Audio settings menu functions
func _on_exit_audio_settings_pressed():
	#print("exiting settings")
	saver_loader.save_game()
	set_game_paused(false)
	audio_settings.visible = false
	
	if player_in_pause_menu:
		_on_pause_press()
	elif player_in_settings_menu:
		_on_settings_pressed()

func _on_exit_control_settings_pressed():
	set_game_paused(false)
	controls.visible = false
	
	if player_in_pause_menu:
		_on_pause_press()
	elif player_in_settings_menu:
		_on_settings_pressed()

# Pause menu settings
func _on_pause_press() -> void: # function should be called in game
	set_game_paused(true)
	pause_menu.visible = true
	player_in_pause_menu = true

func _on_pause_exit_pressed() -> void:
	set_game_paused(false)
	pause_menu.visible = false
	player_in_pause_menu = false

func _on_pause_to_title_pressed() -> void:
	title_screen.visible = true
	player_in_pause_menu = false
	
	_on_pause_exit_pressed()
	#EventHandler.quit_game.emit()
	to_title()

func _on_pause_audio_settings_pressed()-> void:
	pause_menu.visible = false
	audio_settings.visible = true

func _on_pause_to_controls_pressed() -> void:
	pause_menu.visible = false
	controls.visible = true

# Settings menu settings
func _on_settings_pressed():
	settings_menu.visible = true
	player_in_settings_menu = true

func _on_settings_audio_settings_pressed() -> void:
	settings_menu.visible = false
	audio_settings.visible = true

func _on_settings_control_settings_pressed() -> void:
	settings_menu.visible = false
	controls.visible = true

func _on_settings_to_title_pressed() -> void:
	set_game_paused(false)
	settings_menu.visible = false
	player_in_settings_menu = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if title_screen.visible:
			return
		elif audio_settings.visible:
			_on_exit_audio_settings_pressed()
			_on_pause_exit_pressed()
		elif controls.visible:
			_on_exit_control_settings_pressed()
			_on_pause_exit_pressed()
		elif pause_menu.visible:
			_on_pause_exit_pressed()
		else :
			_on_pause_press()

const GAME = preload("res://Scenes/Main/game.tscn")

func to_title() ->void:
	game.queue_free()
	AudioHandler.stop_all_sounds()
	Dialogic.end_timeline()
	
	AudioHandler.lerp_from_none_to_max(AudioHandler.title)
	
	
