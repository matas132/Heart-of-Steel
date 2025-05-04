extends Control

@onready var target: TextureRect = $Target
@onready var circle_progress_bar: AnimatedTextureProgressBar = $CircleProgressBar

const MOVEMENT_DURATION = 0.8
const CIRCLE_MOVING_BACK_DURATION = 1.2

const CIRCLE_LOWEST_ROT = -215
const CIRCLE_HIGHEST_ROT = -260


#CIRCLE_HIGHEST_ROT < x < CIRCLE_LOWEST_ROT
func _ready() -> void:
	circle_progress_bar.init(360)
	circle_progress_bar.value = 0.0

func _on_button_pressed() -> void:
#	if target.rotation_degrees == 0:
#		move_circle()
	pass
	
	if CIRCLE_HIGHEST_ROT < target.rotation_degrees && target.rotation_degrees < CIRCLE_LOWEST_ROT:
		on_finish()
	else:
		AudioHandler.rocket_reload_failure.play()
	


func _physics_process(delta: float) -> void:
	pass
	#target.rotation_degrees =  (target.rotation_degrees * target.rotation_degrees * (-1) +180) * delta
	
	#target.rotation_degrees += (-0.01 *(target.rotation_degrees-180)*(target.rotation_degrees-180) +180 ) * delta
	
	
	
	#target.rotation_degrees += 40 * delta
	
#	if target.rotation_degrees <-360:
#		target.rotation_degrees = 0
	
#	var speed : float = -40
#	print(str(snapped((-1)* cos(target.rotation_degrees * (-1 *(PI/180))),0.01)))

	var rot_values :float = snappedf((((-1.0/32400.0) * target.rotation_degrees * target.rotation_degrees) + (-1.0/90.0) * target.rotation_degrees),0.001)
	
#	print(str(rot_values))
	
	# y = kx+b  , change b to change its lowest speed, k to change its highest speed and something else
	var speed_values :float = rot_values*90 + 35
	target.rotation_degrees+=-speed_values * 1.15 * delta
#	var cos_values :float = snapped((-1)* cos(target.rotation_degrees * (-1 *(PI/180))),0.01)
#	print(str(cos_values))
#	var speed_values : float = (cos_values * 20 + 60)
#	20 * x +60
#	print(str(speed_values))
#	target.rotation_degrees += (-1)* speed_values * delta *0.5
	
	if target.rotation_degrees <-360:
		target.rotation_degrees = 0
	
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
	
	AudioHandler.rocket_reload_success.play()
	target.rotation_degrees = 0
#	circle_progress_bar.value = 0
