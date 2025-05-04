extends TextureRect

func _ready() -> void:
	Dialogic.timeline_ended.connect(on_timeline_ended)
	#visible = false
	modulate = Color(1,1,1,0)

func on_timeline_ended()->void:
	
	
	#var tween = create_tween().tween_property(self,"modulate",Color(1,1,1,0),0.5)
	#await tween.finished
	create_tween().tween_property(self,"modulate",Color(1,1,1,1),0.7)
	
