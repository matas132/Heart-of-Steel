extends Node
const FLASH_LIGHT = preload("res://CustomResources/Shaders/flash_light.tres")
@onready var v_scroll_bar: VScrollBar = $"../CanvasLayer/LaserShotgunMinigame/VScrollBar"

func _ready() -> void:
	EventHandler.reload_ammo.connect(on_reload_ammo)
	Dialogic.timeline_ended.connect(on_ending_time)

func on_ending_time()->void:
	v_scroll_bar.material = FLASH_LIGHT
	

func on_reload_ammo(weapon_type: GlobalVar.weapon_types)->void:
	if weapon_type == GlobalVar.weapon_types.LASER_SHOTGUN:
		EventHandler.waves_finished.emit()
		v_scroll_bar.material = null
