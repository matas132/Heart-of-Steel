extends Node

const DAMAGE_DISPLAY = preload("res://Scenes/Components/damage_display.tscn")
const TEXT_OUTPUT = preload("res://Scenes/Components/text_output.tscn")

func _ready() -> void:
	EventHandler.vfx_enemy_hit.connect(damage_display_vfx)
	EventHandler.vfx_text_output.connect(on_text_output)
	
func damage_display_vfx(damage: float, enemy_center: Vector2) ->void:
	var damage_display : Label = DAMAGE_DISPLAY.instantiate()
	
	add_child(damage_display)
	damage_display.text = str(snappedf(damage,1))
	damage_display.global_position = enemy_center + Vector2(-40,-70)
	

func on_text_output(text: String, pos: Vector2, text_color: Color, text_size : int = 18)->void:
	var text_output : Label = TEXT_OUTPUT.instantiate()
	add_child(text_output)
	text_output.text = text
	var lebel_set = LabelSettings.new()
	lebel_set.font_size = text_size
	lebel_set.font_color = text_color
	lebel_set.outline_color = Color(0,0,0,1)
	lebel_set.outline_size = 3
	#text_output.label_settings.font_size = text_size
	#text_output.label_settings.font_color = text_color

	text_output.label_settings = lebel_set
	text_output.global_position = pos + Vector2(-150,-40)
	text_output.start_animation()
