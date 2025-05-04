extends Button
@onready var camera_2d: Camera2D = $"../../Camera2D"
@onready var margin_container: MarginContainer = $"../MarginContainer"





func _on_pressed() -> void:
	Shaker.shake(camera_2d,10)
