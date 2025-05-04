extends CanvasLayer


@onready var screen_color: ColorRect = $ScreenColor
@onready var mouse_input_prevention: ColorRect = $MouseInputPrevention

@onready var screen_color_white: ColorRect = $ScreenColorWhite


signal animation_finished

func fade_in_screen_from_black(duration:float)->void:
	if screen_color.modulate.a == 0:
		screen_color.modulate.a = 1.0
	screen_color.mouse_filter =Control.MOUSE_FILTER_STOP
	
	var fade_in_tween = create_tween()
	fade_in_tween.tween_property(screen_color,"modulate", Color(0,0,0,0),duration)
	
	await fade_in_tween.finished
	screen_color.mouse_filter = Control.MOUSE_FILTER_IGNORE
	animation_finished.emit()
	
func prevent_mouse_input(duration:float)->void:
	mouse_input_prevention.mouse_filter =Control.MOUSE_FILTER_STOP
	await get_tree().create_timer(duration,false).timeout
	mouse_input_prevention.mouse_filter = Control.MOUSE_FILTER_IGNORE
	animation_finished.emit()


func fade_screen_to_black(duration:float)->void:
	var fade_tween = create_tween()
	screen_color.mouse_filter = Control.MOUSE_FILTER_STOP
	screen_color.modulate = Color(0,0,0,0)
	fade_tween.tween_property(screen_color,"modulate", Color(0,0,0,1),duration)
	await fade_tween.finished
	screen_color.mouse_filter = Control.MOUSE_FILTER_IGNORE
	animation_finished.emit()

func fade_screen_to_white(duration:float)->void:
	var fade_tween = create_tween()
	screen_color_white.mouse_filter = Control.MOUSE_FILTER_STOP
	screen_color_white.modulate = Color(1,1,1,0)
	fade_tween.tween_property(screen_color_white,"modulate", Color(1,1,1,1),duration)
	await fade_tween.finished
	screen_color_white.mouse_filter = Control.MOUSE_FILTER_IGNORE
	animation_finished.emit()


func do_ending()->void:
	AudioHandler.start_sound_with_signal(AudioHandler.self_destruct)
	await get_tree().create_timer(5.207).timeout
	fade_screen_to_white(1.5)
	
	
	
	await AudioHandler.sound_finished
	screen_color.modulate = Color(0,0,0,1)
	
	
	await animation_finished
	screen_color_white.modulate = Color(1,1,1,0)
	
	await get_tree().create_timer(5).timeout
	fade_in_screen_from_black(3)
	
	
	

#func _ready() -> void:
#	do_ending()
