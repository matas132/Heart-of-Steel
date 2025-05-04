extends Control

@onready var target: TextureRect = $Target
@onready var circle_progress_bar: AnimatedTextureProgressBar = $CircleProgressBar

const MOVEMENT_DURATION = 0.8
const CIRCLE_MOVING_BACK_DURATION = 1.2

func _ready() -> void:
	circle_progress_bar.init(360)
	circle_progress_bar.value = 0.0

func _on_button_pressed() -> void:
	if target.rotation_degrees == 0:
		move_circle()

func move_circle() ->void:
	var rand_progress : float = clampf(randf_range(100,200),0,circle_progress_bar.max_value - circle_progress_bar.value) 
	var circle_movement : float = -1 * (rand_progress + circle_progress_bar.value)
	
	create_tween().tween_property(target,"rotation_degrees",circle_movement ,MOVEMENT_DURATION)
	var move_progress : PropertyTweener = create_tween().tween_property(circle_progress_bar,"value", circle_progress_bar.value + rand_progress ,MOVEMENT_DURATION)
	
	await move_progress.finished
	if circle_progress_bar.value == 360:
		on_finish()
	else:
		create_tween().tween_property(target,"rotation_degrees",0 ,CIRCLE_MOVING_BACK_DURATION)

func on_finish() ->void:
	EventHandler.reload_ammo.emit(GlobalVar.weapon_types.PRECISION_ROCKET)
	target.rotation_degrees = 0
	circle_progress_bar.value = 0
