extends Control

const CALM = preload("res://Assets/Sprites/HUD/Player/Calm.png")
const SAD = preload("res://Assets/Sprites/HUD/Player/Sad.png")
const ANGRY = preload("res://Assets/Sprites/HUD/Player/Angry1.png")
const HAPPY = preload("res://Assets/Sprites/HUD/Player/Happy.png")
@onready var emotion: TextureRect = $Emotion

func _ready() -> void:
	EventHandler.emotion_changed.connect(on_emotion_changed)
	#emotion.visible = true
	
	Dialogic.timeline_started.connect(on_dialogue_start)
	Dialogic.timeline_ended.connect(on_dialogue_end)
	
	#EventHandler.start_game.connect(on_start_game)
	#EventHandler.waves_finished.connect(on_waves_finished)

func on_dialogue_start()->void:
	#await get_tree().create_timer(0.5).timeout
	#var tween = create_tween().tween_property(self,"modulate",Color(1,1,1,0),0.5)
	create_tween().tween_property(self,"modulate",Color(1,1,1,0),0.3)
	#await tween.finished
	#emotion.visible = false
	
func on_dialogue_end()->void:
	modulate = Color(1,1,1,1)
	#emotion.visible = true




#func on_start_game()->void:
#	emotion.visible = true



func on_emotion_changed(new_emotion: GlobalVar.emotion_type)->void:
	match new_emotion:
		GlobalVar.emotion_type.DEFAULT:
			emotion.texture = CALM
		GlobalVar.emotion_type.SAD:
			emotion.texture = SAD
		GlobalVar.emotion_type.ANGRY:
			emotion.texture = ANGRY
		GlobalVar.emotion_type.HAPPY:
			emotion.texture = HAPPY
