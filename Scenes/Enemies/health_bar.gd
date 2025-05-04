class_name HealthBar
extends ProgressBar

func init_health_bar(max_health: float) ->void:
	
	max_value = max_health
	value = max_value

func update_health_bar(health: float) ->void:
	
	value = health
