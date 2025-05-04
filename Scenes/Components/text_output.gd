extends Label


func start_animation()->void:
	var tween = create_tween().tween_property(self,"position",Vector2(position.x,position.y-30),1.6)
	await tween.finished
	queue_free()
