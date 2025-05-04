extends Control
@onready var texture_progress_bar: AnimatedTextureProgressBar = $TextureProgressBar
@onready var meter_charge_rate: Timer = $MeterChargeRate

@export var laser_shotgun_max_value :float = 100.0
@export var charge_rate :float = 7.0



var left_click_held : bool = false
var mouse_inside : bool = false

var meter_moving_down : bool = false

func _ready() -> void:
	texture_progress_bar.init(laser_shotgun_max_value)
	texture_progress_bar.value = 0.0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		if mouse_inside && !meter_moving_down:
			meter_charge_rate.start()
			
	
	if event.is_action_released("left_click"):
			meter_charge_rate.stop()
	
	
	
	

func _on_hold_button_mouse_entered() -> void:
	mouse_inside = true


func _on_hold_button_mouse_exited() -> void:
	mouse_inside = false
	left_click_held = false


func _on_meter_charge_rate_timeout() -> void:
	if !mouse_inside:
		meter_charge_rate.stop()
	
	
	texture_progress_bar.update(texture_progress_bar.value +charge_rate)
	
	if texture_progress_bar.value >= texture_progress_bar.max_value:
		on_meter_full()
		meter_charge_rate.stop()

func on_meter_full() ->void:
	EventHandler.reload_ammo.emit(GlobalVar.weapon_types.LASER_SHOTGUN)
	
	# the animation
	meter_moving_down = true
	var move_down_meter = create_tween()
	move_down_meter.tween_property(texture_progress_bar,"value",0.0,0.5)
	await move_down_meter.finished
	meter_moving_down = false
	
