extends Button

func _on_pressed() -> void:
	#EventHandler.shoot.emit()
	EventHandler.check_ammo.emit()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		_on_pressed()
