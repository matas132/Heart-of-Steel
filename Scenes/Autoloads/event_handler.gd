extends Node

# gameplay signlas
signal start_game
signal enemy_killed(enemy: BaseEnemy)
signal shoot
signal spawn_enemy(enemy: BaseEnemy)

signal mech_take_damage(damage: float)

signal check_ammo

signal reload_ammo(weapon: GlobalVar.weapon_types)

signal highlight_selected_weapon

signal waves_finished

# vfx signals
signal vfx_enemy_hit(damage: float, enemy_center: Vector2)

signal vfx_text_output(text: String, pos: Vector2, text_color: Color, text_size : int)


#emotion signal
signal emotion_changed(new_emotion: GlobalVar.emotion_type)

#menu signlas
signal show_title_screen

signal quit_game

signal save_progress

signal press_pause

#dialogue signals
signal cutscene_ended



signal to_title_quit
