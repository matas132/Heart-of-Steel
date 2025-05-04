class_name WeaponDisplay
extends Control

@onready var highlight: ColorRect = $Highlight

@onready var ammo_bar: AnimatedTextureProgressBar = $AmmoBar

@export var weapon_type: GlobalVar.weapon_types = GlobalVar.weapon_types.NULL

@export var max_ammo : float = 0.0
var ammo :float = 0.0:
	set(value):
		ammo = value
		ammo_bar.update(ammo)
	get:
		return ammo

func _ready() -> void:
	ammo = max_ammo
	ammo_bar.init(max_ammo)
	EventHandler.highlight_selected_weapon.connect(on_highlight_selected_weapon)


func _on_button_pressed() -> void:
	GlobalVar.current_weapon = weapon_type
	EventHandler.highlight_selected_weapon.emit()

func on_highlight_selected_weapon()->void:
	if GlobalVar.current_weapon == weapon_type:
		highlight.visible = true
		AudioHandler.weapon_select.play()
	else:
		highlight.visible = false
		pass
	
	
