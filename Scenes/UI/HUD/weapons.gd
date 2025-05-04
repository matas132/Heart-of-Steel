extends VBoxContainer

@onready var machine_gun: WeaponDisplay = $MachineGun
@onready var laser_shotgun: WeaponDisplay = $LaserShotgun
@onready var precision_rocket: WeaponDisplay = $PrecisionRocket

#@onready var crosshair: Area2D = %Crosshair
@onready var crosshair: Area2D = $"../../../../../../CanvasLayer2/Crosshair"

@onready var weapons = {
	GlobalVar.weapon_types.MACHINE_GUN:machine_gun,
	GlobalVar.weapon_types.LASER_SHOTGUN:laser_shotgun,
	GlobalVar.weapon_types.PRECISION_ROCKET:precision_rocket,
}

func _ready() -> void:
	EventHandler.check_ammo.connect(on_check_ammo)
	EventHandler.reload_ammo.connect(on_reload_ammo)

func _input(event: InputEvent) -> void:
	if GlobalVar.dialogue_in_progress:
		return
	
	if event.is_action_pressed("select_first_weapon"):
		if GlobalVar.current_weapon != GlobalVar.weapon_types.MACHINE_GUN:
			machine_gun._on_button_pressed()
	if event.is_action_pressed("select_second_weapon"):
		if GlobalVar.current_weapon != GlobalVar.weapon_types.LASER_SHOTGUN:
			laser_shotgun._on_button_pressed()
			
	if event.is_action_pressed("select_third_weapon"):
		
		if GlobalVar.current_weapon != GlobalVar.weapon_types.PRECISION_ROCKET:
			precision_rocket._on_button_pressed()
	
	



func on_check_ammo() ->void:
	if GlobalVar.dialogue_in_progress:
		return

	if GlobalVar.current_weapon == GlobalVar.weapon_types.NULL:
		EventHandler.vfx_text_output.emit("NO WEAPON SELECTED", crosshair.position, Color(0.5,0.5,0.5,1))
		return
	
	var current_weapon :WeaponDisplay = weapons[GlobalVar.current_weapon]
	
	if current_weapon.ammo > 0:
		current_weapon.ammo -=1
		EventHandler.shoot.emit()
		
	else:
		EventHandler.vfx_text_output.emit("OUT OF AMMO", crosshair.position + Vector2(10,0), Color(1,0,0,1),17)
		AudioHandler.no_ammo_fire.play()

func on_reload_ammo(weapon_type: GlobalVar.weapon_types):
	if GlobalVar.dialogue_in_progress:
		return

	if weapon_type == GlobalVar.weapon_types.NULL:
		return
	
	var reloading_weapon :WeaponDisplay = weapons[weapon_type]
	reloading_weapon.ammo = reloading_weapon.max_ammo
	
