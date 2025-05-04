extends Node

enum enemies {
	NULL,
	LONG_GODOT,
	MONSTROSITY,
	ATLAS_CLASS_MONSTER_SKETCH_4,
	ANT,
	CENTIPEDE,
	MANTIS,
	SPIDER,
	ZOMBIE,
	
}

enum enemy_types{
	ORGANIC_CREATURE,
	METALLIC_CONSTRUCT,
	ATLAS_CLASS,
	
}

enum weapon_types{
	NULL,
	MACHINE_GUN,
	LASER_SHOTGUN,
	PRECISION_ROCKET,
	
}

var current_weapon :weapon_types = weapon_types.NULL

@onready var base_weapon_damage = {
	weapon_types.NULL: 0.0,
	weapon_types.MACHINE_GUN: 10.0,
	weapon_types.LASER_SHOTGUN: 40.0,
	weapon_types.PRECISION_ROCKET: 100.0,
	
}


func get_damage(enemy_type: enemy_types)->float:
	var damage :float = base_weapon_damage[current_weapon]
	damage *= get_damage_mult(enemy_type)
	
	return damage


func get_damage_mult(enemy_type: enemy_types)->float:
	var damage_mult:float = 1
	match enemy_type:
		enemy_types.ORGANIC_CREATURE:
			match current_weapon:
				weapon_types.MACHINE_GUN:
					damage_mult =1.5
				weapon_types.LASER_SHOTGUN:
					damage_mult = 0.2
				weapon_types.PRECISION_ROCKET:
					damage_mult = 0.7
	
	
		enemy_types.METALLIC_CONSTRUCT:
			match current_weapon:
				weapon_types.MACHINE_GUN:
					damage_mult =0.7
				weapon_types.LASER_SHOTGUN:
					damage_mult = 1.3
				weapon_types.PRECISION_ROCKET:
					damage_mult = 0.5
		
		
		enemy_types.ATLAS_CLASS:
			match current_weapon:
				weapon_types.MACHINE_GUN:
					damage_mult =0.1
				weapon_types.LASER_SHOTGUN:
					damage_mult = 0.1
				weapon_types.PRECISION_ROCKET:
					damage_mult = 5
			
	
	
	return damage_mult



#for the emotions
enum emotion_type {
	DEFAULT,
	SAD,
	ANGRY,
	HAPPY,
}

var current_emotion: emotion_type = emotion_type.DEFAULT

func set_emotion(emotion: emotion_type)->void:
	current_emotion = emotion
	EventHandler.emotion_changed.emit(current_emotion)

#gameplay
var current_health := 1000

#dialogue signals
var dialogue_in_progress : bool = false

var dialogue_play_static : bool = false

func dialogue_play_static_set(play: bool)->void:
	dialogue_play_static = play

func _ready() -> void:
	Dialogic.timeline_started.connect(on_dialogue_start)
	Dialogic.timeline_ended.connect(on_dialogue_end)

func on_dialogue_start()->void:
	dialogue_in_progress = true
	
func on_dialogue_end()->void:
	dialogue_in_progress = false




# game progress/saving
var current_level :int = 1
