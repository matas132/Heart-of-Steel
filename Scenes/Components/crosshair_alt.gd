extends Area2D
@onready var change_target_timer: Timer = $ChangeTargetTimer

enum movement_type {
	WAITING_FOR_ENEMY,
	MOVING_TO_ENEMY,
	AIMING,
}

enum emotion_type {
	DEFAULT,
	SAD,
	ANGRY,
	HAPPY,
}

var current_emotion: emotion_type = emotion_type.DEFAULT
var current_movement : movement_type = movement_type.WAITING_FOR_ENEMY

var current_enemy : BaseEnemy

var speed :float = 110.0
var aim_speed : float = 90.0

var instability: float = 5.0  # For wobble in DEFAULT
var max_aim_distance : float = 30.0
var aim_direction : int = 1
var current_aim_distance : float = 0.0

func _ready() -> void:
	EventHandler.enemy_killed.connect(on_enemy_killed)
	EventHandler.shoot.connect(on_shoot)

func _physics_process(delta: float) -> void:
	match current_movement:
		movement_type.MOVING_TO_ENEMY:
			move_towards_enemy(delta)
		movement_type.AIMING:
			aim_at_target(delta)

func move_towards_enemy(delta: float) -> void:
	var instability_value: float = 0
	var sudden_drag_chance: float = 0
	var reselect_target: bool = false
	var auto_assist: bool = false
	
	match current_emotion:
		emotion_type.DEFAULT:
			# Reduce instability near the target
			if global_position.distance_to(current_enemy.center.global_position) > 10.0:
				instability_value = instability * randf_range(-1, 1)
			else:
				instability_value = instability * 0.1 * randf_range(-1, 1)
		
		emotion_type.SAD:
			sudden_drag_chance = 0.05
			if randf() < sudden_drag_chance:
				var random_offset = Vector2(randf_range(-50, 50), randf_range(-50, 50))
				global_position += random_offset * delta
				return
		
		emotion_type.ANGRY:
			reselect_target = true
		
		emotion_type.HAPPY:
			auto_assist = true
	
	# Delegate movement to the helper function
	move_to_target(delta, instability_value, reselect_target, auto_assist)
	
	# Check if close enough to switch to AIMING
	if global_position.distance_to(current_enemy.center.global_position) < 1.0:
		current_movement = movement_type.AIMING

func move_to_target(delta: float, local_instability: float = 0, reselect_target: bool = false, auto_assist: bool = false) -> void:
	if reselect_target:
		change_target()
	elif auto_assist and current_enemy:
		var assist_vector = global_position.direction_to(current_enemy.center.global_position) * speed * delta * 0.9
		global_position += assist_vector + Vector2(local_instability, local_instability)
	else :
		global_position += global_position.direction_to(current_enemy.center.global_position + Vector2(local_instability, local_instability)) * speed * delta

func aim_at_target(delta: float) -> void:
	match current_emotion:
		emotion_type.DEFAULT:
			slow_stable_aim(delta)
		emotion_type.SAD:
			stable_aim(delta)
		emotion_type.ANGRY:
			erratic_reselection()
		emotion_type.HAPPY:
			slight_auto_aim(delta)

func slow_stable_aim(delta: float) -> void:
	global_position.x += aim_speed * aim_direction * delta
	current_aim_distance += aim_speed * delta
	if max_aim_distance - current_aim_distance < 1:
		current_aim_distance -= max_aim_distance * 2
		aim_direction *= -1

func stable_aim(delta: float) -> void:
	# No wobble, slow stable aiming for SAD
	global_position.x += aim_speed * 0.5 * aim_direction * delta
	current_aim_distance += aim_speed * 0.5 * delta

func erratic_reselection() -> void:
	if randf() < 0.1:  # Add delay between target changes
		change_target()
	current_movement = movement_type.MOVING_TO_ENEMY

func slight_auto_aim(delta: float) -> void:
	# Slight correction toward the target
	var assist_vector = global_position.direction_to(current_enemy.center.global_position) * speed * delta * 0.7
	global_position += assist_vector + Vector2(randf_range(-1, 1), randf_range(-1, 1)) * 2  # Playful wobble

func change_target() ->void:
	if get_tree().get_node_count_in_group("Enemy") > 0:
		var enemies = get_tree().get_nodes_in_group("Enemy")
		
		match current_emotion:
			emotion_type.DEFAULT:
				# Closest or least health for DEFAULT
				enemies.sort_custom(Callable(self, "_sort_by_distance_or_health"))
			emotion_type.SAD:
				# Closest to crosshair
				enemies.sort_custom(Callable(self, "_sort_by_crosshair_distance"))
			emotion_type.ANGRY:
				# Random target
				current_enemy = enemies[randi() % enemies.size()]
				return
			emotion_type.HAPPY:
				# Weakest or nearest target
				enemies.sort_custom(Callable(self, "_sort_by_vulnerability"))
		
		current_enemy = enemies[0]
		current_movement = movement_type.MOVING_TO_ENEMY
		aim_direction = 1
		current_aim_distance = 0
	else :
		current_movement = movement_type.WAITING_FOR_ENEMY
		change_target_timer.start()

func _sort_enemies(a: BaseEnemy, b: BaseEnemy, criterion: String) -> int:
	if criterion == "distance":
		return -1 if a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position) else 1
	elif criterion == "health":
		return -1 if a.health < b.health else 1
	# Default fallback
	return 0

func _sort_by_distance_or_health(a: BaseEnemy, b: BaseEnemy) -> int:
	var a_score = a.global_position.distance_to(global_position)
	var b_score = b.global_position.distance_to(global_position)
	return -1 if a_score < b_score else (1 if a_score > b_score else  0)

func _sort_by_crosshair_distance(a: BaseEnemy, b: BaseEnemy) -> int:
	var a_dist = a.global_position.distance_to(global_position)
	var b_dist = b.global_position.distance_to(global_position)
	return -1 if a_dist < b_dist else (1 if a_dist > b_dist else 0)

func _sort_by_vulnerability(a: BaseEnemy, b: BaseEnemy) -> int:
	#var a_vuln = a.health  # Example: health represents vulnerability
	#var b_vuln = b.health
	var a_vuln = a.global_position.distance_to(global_position)
	var b_vuln = b.global_position.distance_to(global_position)
	# Since health is not set yet, sorting by distance or a default value
	return -1 if a_vuln < b_vuln else (1 if a_vuln > b_vuln else 0)

func on_enemy_killed(killed_enemy: BaseEnemy) ->void:
	if current_enemy == killed_enemy:
		change_target()

func _on_change_target_timer_timeout() -> void:
	change_target()

func on_shoot()->void:
	for area in get_overlapping_areas():
		if area is BaseEnemy:
			area.take_damage()
		else :
			print("Warning: Overlapping area is not a BaseEnemy.")
