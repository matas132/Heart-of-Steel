extends Node
@onready var left_top: Marker2D = $LeftTop
@onready var right_bottom: Marker2D = $RightBottom

func get_random_spawn_pos() -> Vector2:
	#print(str(left_top.position))
	return Vector2(randf_range(left_top.position.x, right_bottom.position.x), randf_range(left_top.position.y, right_bottom.position.y))
