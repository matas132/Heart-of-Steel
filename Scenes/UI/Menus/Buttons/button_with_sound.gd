class_name SoundButton
extends Button

func _ready() ->void:
	mouse_entered.connect(_on_mouse_entered)
	pressed.connect(_on_pressed)

func _on_mouse_entered() ->void: 
#	AudioHandler.play_sound(AudioHandler.SFX.UI_SELECT)
	AudioHandler.ui_choose.play()

func _on_pressed() -> void:
	#AudioHandler.play_sound(AudioHandler.SFX.UI_CHOOSE)
	AudioHandler.ui_confirm.play()
	_button_press()

func _button_press()->void:
	pass
