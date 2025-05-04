extends Control


func _on_button_pressed() -> void:
	EventHandler.to_title_quit.emit()
