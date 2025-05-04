class_name Game
extends Node
const HUD_LEVEL_0 = preload("res://Scenes/UI/HUD/hud.tscn")
const LEVEL_1 = preload("res://Scenes/Levels/level_1.tscn")
const LEVEL_2 = preload("res://Scenes/Levels/level_2.tscn")
const LEVEL_3 = preload("res://Scenes/Levels/level_3.tscn")
const LEVEL_4 = preload("res://Scenes/Levels/level_4.tscn")

const FIRST_TRANSMISSION = preload("res://CustomResources/Dialogic/Level1/first_transmission.dtl")
const SECOND_TRANSMISSION = preload("res://CustomResources/Dialogic/Level2/second_transmission.dtl")
const THIRD_TRANSMISSION = preload("res://CustomResources/Dialogic/Level3/third_transmission.dtl")
const ENDING_DIALOGUE = preload("res://CustomResources/Dialogic/ending/ending_dialogue.dtl")

var first_transmission
var second_transmission
var third_transmission
var ending_dialogue

var current_level


const TITLE_SCREEN = preload("res://Scenes/UI/Menus/TitleScreen/title_screen.tscn")
const THANK_YOU_FOR_PLAYING = preload("res://Scenes/UI/End/thank_you_for_playing.tscn")

func _ready() -> void:
	EventHandler.waves_finished.connect(on_waves_finished)
	
	first_transmission = Dialogic.preload_timeline(FIRST_TRANSMISSION)
	second_transmission = Dialogic.preload_timeline(SECOND_TRANSMISSION)
	third_transmission = Dialogic.preload_timeline(THIRD_TRANSMISSION)
	ending_dialogue = Dialogic.preload_timeline(ENDING_DIALOGUE)
	
#	EventHandler.quit_game.connect(on_quit_game)


func game_start()->void:
	match GlobalVar.current_level:
		1:
			GlobalVar.current_health = 1000
			
			Dialogic.start("opening_crawl")
			#await EventHandler.cutscene_ended
			await Dialogic.timeline_ended
			var style: DialogicStyle = load("res://Scenes/UI/DialogicStyles/Cmdr_Style.tres")
			style.prepare()
			await get_tree().create_timer(1, false).timeout
			current_level = LEVEL_1.instantiate()
			
			Dialogic.Styles.change_style("Cmdr_Style")
			
			Vfx.fade_in_screen_from_black(3.0)
			add_child(current_level)
			await Vfx.animation_finished
			
			Vfx.prevent_mouse_input(2.0)
			await Vfx.animation_finished
			Dialogic.start(first_transmission)
			
			#AudioHandler.play_music(AudioHandler.MUSIC.OPENING)
			await Dialogic.timeline_ended
			await get_tree().create_timer(1, false).timeout
			#put the tutorial here?
			EventHandler.start_game.emit()
		2:
			
			current_level = LEVEL_2.instantiate()
			
			Vfx.fade_in_screen_from_black(2.5)
			add_child(current_level)
			await Vfx.animation_finished
			Dialogic.start(second_transmission)
			#AudioHandler.play_music(AudioHandler.MUSIC.OPENING)
			
			
			await Dialogic.timeline_ended
			EventHandler.start_game.emit()
		
		3:
			current_level = LEVEL_3.instantiate()
			
			Vfx.fade_in_screen_from_black(2.0)
			add_child(current_level)
			await Vfx.animation_finished
			Dialogic.start(third_transmission)
			#AudioHandler.play_music(AudioHandler.MUSIC.OPENING)
			await Dialogic.timeline_ended
			EventHandler.start_game.emit()
		4:
			current_level = LEVEL_4.instantiate()
			Vfx.fade_in_screen_from_black(2.0)
			add_child(current_level)
			await Vfx.animation_finished
			Dialogic.start(ending_dialogue)
			
			#await Dialogic.timeline_ended
			#EventHandler.start_game.emit()
		

func on_waves_finished()->void:
	GlobalVar.current_weapon = GlobalVar.weapon_types.NULL
	match GlobalVar.current_level:
		1:
			#AudioHandler.lerp_to_specific_volume(AudioHandler.gameplay_01,0.001,4.0)
			
			GlobalVar.current_level=2
			Vfx.fade_screen_to_black(4.0)
			await Vfx.animation_finished
			current_level.queue_free()
			game_start()
		2:
			#AudioHandler.lerp_to_specific_volume(AudioHandler.gameplay_01,0.001,3)
			
			GlobalVar.current_level=3
			Vfx.fade_screen_to_black(3)
			await Vfx.animation_finished
			current_level.queue_free()
			game_start()
			
		3:
			#AudioHandler.lerp_to_specific_volume(AudioHandler.gameplay_01,0.001,3)
			
			GlobalVar.current_level=4
			Vfx.fade_screen_to_black(3)
			
			await Vfx.animation_finished
			current_level.queue_free()
			game_start()
			
			
			#EventHandler.show_title_screen.emit()
			#Vfx.fade_in_screen_from_black(3)
			
		4:
			GlobalVar.current_level=1
			
		#	AudioHandler.start_sound_with_signal(AudioHandler.self_destruct)
		#	await get_tree().create_timer(5.207,false).timeout
		#	Vfx.fade_screen_to_white(1)
			
			
		#	await AudioHandler.sound_finished

		#	Vfx.fade_screen_to_black(0.05)
			
			Vfx.do_ending()
			
			await get_tree().create_timer(10.0,false).timeout
			current_level.queue_free()
			
			var ending = THANK_YOU_FOR_PLAYING.instantiate()
			add_child(ending)
			#Vfx.fade_in_screen_from_black(3)
			#Vfx.screen_color_white.visible = false
			
			
			#await get_tree().create_timer(2).timeout
			#var title = TITLE_SCREEN.instantiate()
		#	add_child(title)
			
			
			
			
			
			
			
			#EventHandler.show_title_screen.emit()
			#Vfx.fade_in_screen_from_black(3)

	EventHandler.save_progress.emit()

#func on_quit_game()->void:
#	for child in get_children():
#		child.queue_free()
#	AudioHandler.stop_all_sounds()
#	Dialogic.end_timeline()
		
		
