extends Area2D
@onready var change_target_timer: Timer = $ChangeTargetTimer
@onready var collision_shape_2d : CollisionShape2D = $CollisionShape2D
@onready var anger_timer : Timer = $anger_timer
@onready var shake_timer: Timer = $ShakeTimer
@onready var shotgun_laser_collision: CollisionShape2D = $ShotgunLaserCollision


enum movement_type {
	WAITING_FOR_ENEMY,
	MOVING_TO_ENEMY,
	AIMING,
}



var shake_strenght :float = 0.7
var shake_time : float = 0.05

var current_movement : movement_type = movement_type.WAITING_FOR_ENEMY
#var current_emotion : emotion_type = emotion_type.DEFAULT

var current_enemy : BaseEnemy
var speed : float
var default_speed : float = 140.0
var sad_speed : float = 130.0
var angry_speed : float = 155.0

var max_aim_distance_x : float = 30.0
var aim_speed_x : float = 70.0
var current_aim_distance_x : float = 0.0
var aim_direction_x : int = 1

var max_aim_distance_y : float = 7.0
var aim_speed_y : float = 45.0
var current_aim_distance_y : float = 0.0
var aim_direction_y : int = 1

func _ready() -> void:
	speed = default_speed
	EventHandler.enemy_killed.connect(on_enemy_killed)
	EventHandler.shoot.connect(on_shoot)

func _physics_process(delta: float) -> void:
	match current_movement:
		
		movement_type.MOVING_TO_ENEMY:
			global_position +=  global_position.direction_to(current_enemy.center.global_position) * speed * delta
			if global_position.distance_to(current_enemy.center.global_position) < 3.0:
				current_movement = movement_type.AIMING
				shake_timer.start(shake_time)
				if GlobalVar.current_emotion == GlobalVar.emotion_type.ANGRY:
					anger_timer.start(0.4) # 1 Sec delay before switching target
		
		movement_type.AIMING:
			if GlobalVar.current_emotion != GlobalVar.emotion_type.ANGRY or not anger_timer.is_stopped():
				global_position.x += aim_speed_x * aim_direction_x * delta
				current_aim_distance_x += aim_speed_x * delta
				if max_aim_distance_x - current_aim_distance_x < 1:
					current_aim_distance_x-= max_aim_distance_x *2
					aim_direction_x*= -1
				
				global_position.y += aim_speed_y * aim_direction_y * delta
				current_aim_distance_y += aim_speed_y * delta
				if max_aim_distance_y - current_aim_distance_y < 1:
					current_aim_distance_y -= max_aim_distance_y *2
					aim_direction_y *= -1

func change_target() ->void:
	if get_tree().get_node_count_in_group("Enemy") != 0:
		var rand_enemy_int :int = randi_range(0, get_tree().get_node_count_in_group("Enemy")-1)
		var rand_enemy : BaseEnemy = get_tree().get_nodes_in_group("Enemy")[rand_enemy_int]
		
		current_enemy = rand_enemy
		
		current_enemy.z_index+=1 #NOTE sets it so the targeted enemy is in the front, this causes some y ordering issues which can make the targeted enemy look like its floating, no clue how to fix this :(
		
		current_movement = movement_type.MOVING_TO_ENEMY
		shake_timer.stop()
		
		# Reset aim states
		aim_direction_x = 1
		current_aim_distance_x = 0
		aim_direction_y = -1
		current_aim_distance_y = 0
		
		# Set speed based on emotion
		match GlobalVar.current_emotion:
			GlobalVar.emotion_type.DEFAULT:
				speed = default_speed
				aim_speed_x = 70.0
				aim_speed_y = 45.0
			GlobalVar.emotion_type.SAD:
				speed = sad_speed
				aim_speed_x = 50.0 # Easier Aiming
				aim_speed_y = 30.5
			GlobalVar.emotion_type.ANGRY:
				speed = angry_speed
				aim_speed_x = 80.0 # Faster aiming
				aim_speed_y = 50.0
			GlobalVar.emotion_type.HAPPY:
				speed = default_speed
				aim_speed_x = 70.0 # normal? aiming
				aim_speed_y = 45.0
		
		return
	
	current_movement = movement_type.WAITING_FOR_ENEMY
	change_target_timer.start()

func on_enemy_killed(killed_enemy: BaseEnemy) ->void:
	if current_enemy == killed_enemy:
		change_target()

func _on_change_target_timer_timeout() -> void:
	change_target()

func _on_anger_timer_timeout() -> void:
	if GlobalVar.current_emotion == GlobalVar.emotion_type.ANGRY:
		change_target()

func on_shoot()->void:
	collision_shape_2d.set_deferred("disabled",true)
	collision_shape_2d.set_deferred("disabled",false)
	shotgun_laser_collision.set_deferred("disabled",true)
	
	if GlobalVar.current_weapon == GlobalVar.weapon_types.LASER_SHOTGUN:
		#shotgun_laser_collision.set_deferred("disabled",true)
		shotgun_laser_collision.set_deferred("disabled",false)
		
		for area in get_overlapping_areas():
			if area is BaseEnemy:
				area.take_damage_from_gun()
		return
	
	
	if current_enemy !=null:
		if get_overlapping_areas().has(current_enemy):
			current_enemy.take_damage_from_gun()
			return
	
	
	for area in get_overlapping_areas():
		if area is BaseEnemy:
			area.take_damage_from_gun()
			return # so only the first enemy is hit, maybe for a laser weapon this should be different

	
#	if current_enemy !=null:
#		if get_overlapping_areas().has(current_enemy):
#			current_enemy.take_damage_from_gun()
#			return
	
	
func _on_shake_timer_timeout() -> void:
	#shake
	var shake_direction : Vector2 = Vector2(randf_range(-1.0,1.0), randf_range(-1.0,1.0))
	
	var shake_vector : Vector2 = shake_strenght * shake_direction
	
	global_position += shake_vector
	
	await get_tree().create_timer(0.1,false).timeout
	global_position -= shake_vector
