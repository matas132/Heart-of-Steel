extends Node

func shake(object, strength: float, duration: float = 0.2, shake_count: int = 10) ->void:
	if not object:
		return
	var orig_pos :Vector2 = object.global_position
	
	var tween := create_tween()
	
	for i in shake_count:
		var shake_offset := Vector2(randf_range(-1.0,1.0), randf_range(-1.0,1.0))
		var target := orig_pos + strength * shake_offset
		if i%2 == 0:
			target = orig_pos
		tween.tween_property(object,"position",target,duration/float(shake_count))
		strength *=0.75
	if not object:
		return
	tween.finished.connect(func(): object.global_position = orig_pos)
		
