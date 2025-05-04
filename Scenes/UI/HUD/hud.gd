extends Control

@onready var health_bar: ProgressBar = $CanvasLayer/MarginContainer/HBoxContainer/Control2/MarginContainer2/ProgressBar
var max_health : float = 1000
var current_health : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = GlobalVar.current_health
	health_bar.init_health_bar(max_health)
	health_bar.value = current_health
	
	EventHandler.mech_take_damage.connect(take_damage)
	EventHandler.start_game.connect(on_start_game)
	EventHandler.waves_finished.connect(on_waves_finished)


func on_waves_finished()->void:
	GlobalVar.current_health = health_bar.value
	AudioHandler.end_gameplay_music()
	

func on_start_game()->void:
	#AudioHandler.lerp_to_specific_volume(AudioHandler.opening_01,0.001,3)
	#await get_tree().create_timer(3).timeout
	#AudioHandler.stop_music(AudioHandler.MUSIC.OPENING)
	
	AudioHandler.start_gameplay_music()
	#AudioHandler.play_music(AudioHandler.MUSIC.GAMEPLAY)

func take_damage(damage : float):
	if current_health > 0 and current_health > damage:
		current_health -= damage
		health_bar.update_health_bar(current_health)
#		print(current_health)
	else :
		you_died()

func you_died():
#	print("You Died!!!")
	AudioHandler.death.play()
	EventHandler.to_title_quit.emit()
	GlobalVar.current_level = 1
	GlobalVar.current_health=1000
	
