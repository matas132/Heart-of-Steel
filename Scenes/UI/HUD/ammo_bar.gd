class_name AnimatedTextureProgressBar
extends TextureProgressBar

func init(new_max_value: float) ->void:
	
	max_value = new_max_value
	value = max_value

func update(new_value: float) ->void:
	create_tween().tween_property(self,"value",new_value,0.1)
#	value = new_value


	
	
