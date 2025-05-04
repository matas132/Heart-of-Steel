extends VScrollBar
@onready var timer: Timer = $Timer

var pressed : bool = false

func _on_scrolling() -> void:
	if !pressed:
		pressed = true
		AudioHandler.shotgun_reload_grab.play()
	
	timer.stop()
	timer.start(0.5)


func _on_timer_timeout() -> void:
	pressed = false
