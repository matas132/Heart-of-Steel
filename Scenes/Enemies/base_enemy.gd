class_name BaseEnemy
extends Area2D
@onready var center: Marker2D = $Center
@onready var health_bar: HealthBar = $HealthBar
@onready var attack_timer: Timer = $AttackTimer
@onready var collision_shape_2d = $CollisionShape2D


#var targetable: bool = true

@export var type : GlobalVar.enemy_types

@export var enemy : GlobalVar.enemies

@export var max_health : float = 0.0

@onready var health : float =max_health

var attack_time_interval : float = 4.0
var attack_damage :float = 3.0

func _ready() -> void:
	health_bar.init_health_bar(max_health)
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	attack_timer.start(attack_time_interval)

func take_damage_from_gun() ->void:
#	print(str(snappedf(GlobalVar.get_damage(type),1)))
	
	var damage: float = GlobalVar.get_damage(type)
	
	health -= damage
	EventHandler.vfx_enemy_hit.emit(damage, center.global_position)
	
	if GlobalVar.get_damage_mult(type) >= 1.0:
		EventHandler.vfx_text_output.emit("EFFECTIVE",center.global_position + Vector2(70,-10),Color(0,1,0,0.7),14)

	else:
		EventHandler.vfx_text_output.emit("INEFFECTIVE",center.global_position+ Vector2(70,-10),Color(0.5,0.35,0,0.7),14)
	
	
#	EventHandler.vfx_enemy_hit_text_output
	health_bar.update_health_bar(health)
	Shaker.shake(self,12)
	if health <= 0:
		on_death()
		return

func on_death() ->void:
	remove_from_group("Enemy")
	collision_shape_2d.set_deferred("disabled", true)
	EventHandler.enemy_killed.emit(self)
	modulate = Color(1,1,1,0.35) # Fade out effect, I'll make a better one D:, this is just debug to show the enemy is defeated
	await get_tree().create_timer(1,false).timeout
	queue_free()


func _on_attack_timer_timeout() -> void:
	EventHandler.mech_take_damage.emit(attack_damage)
