extends Button



func _on_pressed() -> void:
	EventHandler.waves_finished.emit()
