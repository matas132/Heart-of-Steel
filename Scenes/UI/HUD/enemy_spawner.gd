extends Node


#NOTE to create new enemies

# create enemy node that extends BaseEnemy
# add it to enemy group
# go to GlobalVar and add it to the enemies enum - Done
# go to Spawned Enemies node and add it to enemy location dictionary
# go to enemy spawner and add to the enemies dictionary
# go back to the enemy node and set its enemy type to itselfs type

@onready var enemies = {
	GlobalVar.enemies.LONG_GODOT:preload("res://Scenes/Enemies/Prototype/long_godot_enemy.tscn"),
	GlobalVar.enemies.MONSTROSITY:preload("res://Scenes/Enemies/Prototype/monstrosity.tscn"),
	GlobalVar.enemies.ATLAS_CLASS_MONSTER_SKETCH_4:preload("res://Scenes/Enemies/Prototype/atlas_class_monster_sketch_4.tscn"),
	GlobalVar.enemies.ANT:preload("res://Scenes/Enemies/ant.tscn"),
	GlobalVar.enemies.CENTIPEDE:preload("res://Scenes/Enemies/centipede.tscn"),
	GlobalVar.enemies.MANTIS:preload("res://Scenes/Enemies/mantis.tscn"),
	GlobalVar.enemies.SPIDER:preload("res://Scenes/Enemies/spider.tscn"),
	GlobalVar.enemies.ZOMBIE:preload("res://Scenes/Enemies/zombie.tscn"),
	
	
}

@onready var enemy_spawn: Timer = $EnemySpawn
@onready var wave_timer: Timer = $WaveTimer


@export var waves : Array[WaveResource]

const max_enemy_amount : float = 5

var current_wave :int = 0

var waves_finished :bool = false

func _ready() -> void:
	EventHandler.start_game.connect(on_game_start)
	EventHandler.enemy_killed.connect(on_enemy_killed)

func on_game_start() ->void:
	if waves !=null:
		start_wave()

func start_wave()->void:
	wave_timer.start(waves[current_wave].wave_time)
#	enemy_spawn.start(randf_range(0.8, 1.2) * waves[current_wave].enemy_spawn_time) # Randomize the enemy spawn time
	enemy_spawn.start(waves[current_wave].enemy_spawn_time)
func _on_enemy_spawn_timeout() -> void:
	# to make sure the screen doesn't get filled with them max enemy check
	if get_tree().get_node_count_in_group("Enemy") < max_enemy_amount:
		
	
		EventHandler.spawn_enemy.emit(enemies[waves[current_wave].get_random_enemy().enemy].instantiate())
	#print("current time until new wave: " + str(wave_timer.time_left))
func _on_wave_timer_timeout() -> void:
	if current_wave+1 == waves.size():
		
		waves_finished = true
#		EventHandler.waves_finished.emit()
		
		enemy_spawn.paused = true
		wave_timer.paused = true
	else:
#		print("new wave")
		current_wave+=1
		start_wave()

func on_enemy_killed(_enemy: BaseEnemy)->void:
	if get_tree().get_nodes_in_group("Enemy").size() == 0 && waves_finished:
		EventHandler.waves_finished.emit()
	
	
