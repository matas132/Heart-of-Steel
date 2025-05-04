class_name WaveResource
extends Resource

@export var wave_time : float = 10.0
@export var enemy_spawn_time :float = 3.0
@export var enemies : Array[EnemyResource]

func get_random_enemy() -> EnemyResource:
	var total_weight = 0
	for enemy in enemies:
		total_weight += enemy.weight
	
	var random_weight = randi_range(0, total_weight-1)
	
	var weight_sum = 0
	for enemy in enemies:
		weight_sum += enemy.weight
		if random_weight < weight_sum:
			return enemy
	
	return null
