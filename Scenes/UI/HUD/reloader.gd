extends Control


func _on_reload_precision_rocket_pressed() -> void:
	EventHandler.reload_ammo.emit(GlobalVar.weapon_types.PRECISION_ROCKET)


func _on_reload_laser_shotgun_pressed() -> void:
	EventHandler.reload_ammo.emit(GlobalVar.weapon_types.LASER_SHOTGUN)


func _on_reload_machine_gun_pressed() -> void:
	EventHandler.reload_ammo.emit(GlobalVar.weapon_types.MACHINE_GUN)
