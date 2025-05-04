extends Button

func _on_pressed() -> void:
	EventHandler.start_game.emit()
