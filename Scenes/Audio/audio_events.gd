extends Node




func _ready() -> void:
	EventHandler.shoot.connect(on_shoot)

func on_shoot()->void:
	match GlobalVar.current_weapon:
		GlobalVar.weapon_types.MACHINE_GUN:
			AudioHandler.minigun_fire.play()
		GlobalVar.weapon_types.LASER_SHOTGUN:
			AudioHandler.shotgun_fire.play()
		GlobalVar.weapon_types.PRECISION_ROCKET:
			AudioHandler.rocket_fire.play()
