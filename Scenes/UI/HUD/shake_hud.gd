extends Button
@onready var margin_container: MarginContainer = $"../MarginContainer"


func _on_pressed() -> void:
	Shaker.shake(margin_container,10)
