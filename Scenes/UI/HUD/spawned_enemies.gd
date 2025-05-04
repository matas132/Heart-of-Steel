extends Node


@onready var spawn_area_for_long_godot: Node = $"../CanvasLayer/SpawnAreas/SpawnAreaForLongGodot"
@onready var spawn_area_for_monstrosity: Node = $"../CanvasLayer/SpawnAreas/SpawnAreaForMonstrosity"
@onready var spawn_area_for_atlas_class_monster_sketch: Node = $"../CanvasLayer/SpawnAreas/SpawnAreaForAtlasClassMonsterSketch"
@onready var spawn_area_for_ant: Node = $"../CanvasLayer/SpawnAreas/SpawnAreaForAnt"
@onready var spawn_area_for_centipede: Node = $"../CanvasLayer/SpawnAreas/SpawnAreaForCentipede"
@onready var spawn_area_for_mantis: Node = $"../CanvasLayer/SpawnAreas/SpawnAreaForMantis"
@onready var spawn_area_for_spider: Node = $"../CanvasLayer/SpawnAreas/SpawnAreaForSpider"
@onready var spawn_area_for_zombie: Node = $"../CanvasLayer/SpawnAreas/SpawnAreaForZombie"


@onready var enemy_location = {
	GlobalVar.enemies.NULL:spawn_area_for_monstrosity,
	GlobalVar.enemies.LONG_GODOT:spawn_area_for_long_godot,
	GlobalVar.enemies.MONSTROSITY:spawn_area_for_monstrosity,
	GlobalVar.enemies.ATLAS_CLASS_MONSTER_SKETCH_4:spawn_area_for_atlas_class_monster_sketch,
	GlobalVar.enemies.ANT:spawn_area_for_ant,
	GlobalVar.enemies.CENTIPEDE:spawn_area_for_centipede,
	GlobalVar.enemies.MANTIS:spawn_area_for_mantis,
	GlobalVar.enemies.SPIDER:spawn_area_for_spider,
	GlobalVar.enemies.ZOMBIE:spawn_area_for_zombie,
	
	
}

func _ready() -> void:
	EventHandler.spawn_enemy.connect(on_spawn_enemy)

func on_spawn_enemy(enemy: BaseEnemy) ->void:
	add_child(enemy)
	var spawn : Vector2 = enemy_location[enemy.enemy].get_random_spawn_pos()
	enemy.global_position = spawn
	
