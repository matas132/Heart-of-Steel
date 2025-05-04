extends Control

# Nodes
@onready var needle : Sprite2D = $Needle
@onready var green_zone : Sprite2D = $Greenzone
@onready var feedback = $Feedback
@onready var timer = $Timer
@onready var play_button = $PLAY # Button to press when the needle is on greenzone.

# @onready var start_button = $START # Button to press to start the game.

# Variables
var needle_speed = 40  # degrees per second
var needle_angle = -90
var green_zone_start = 0
var green_zone_fixed_size = 30  # Fixed size in degrees

# Minigame State
var is_minigame_active = false
var timer_duration : float = 5

# Starts the minigame
func _ready():
	# Initialize states
	play_button.visible = true
	needle.visible = false
	green_zone.visible = false
	feedback.text = ""
	start_minigame()

func start_minigame():
	is_minigame_active = true
	setup_green_zone()
	needle_angle = -90
	needle.visible = true
	green_zone.visible = true
	timer.start(timer_duration)

func _on_play_button_pressed():
	if is_minigame_active:
		if is_within_green_zone():
			feedback.text = "Success!"
			AudioHandler.minigun_reload_succes.play()
			EventHandler.reload_ammo.emit(GlobalVar.weapon_types.MACHINE_GUN)
		else :
			AudioHandler.minigun_reload_failure.play()
			feedback.text = "Failed!"
		setup_green_zone() # Reset the green zone after pressing the button
		timer.start(timer_duration)  # Restart the timer

func setup_green_zone():
	 # Randomize the start position but keep the size fixed
	green_zone_start = randf_range(-45, 45 - green_zone_fixed_size)
	green_zone.rotation_degrees = green_zone_start
	green_zone.scale.x = green_zone_fixed_size / 45.0  # Ensure visual consistency with a fixed size
	print_debug_info()  # Print the new green zone's info

func _process(delta):
	if is_minigame_active:
		needle_angle += needle_speed * delta
		needle_angle = wrapf(needle_angle, -90, 90)
		needle.rotation_degrees = needle_angle

func _on_timer_timeout():
	# Reset the green zone if the player hasn't pressed the play button
	if is_minigame_active:
		setup_green_zone()
		timer.start(timer_duration)

func is_within_green_zone() -> bool:
	var start = green_zone_start
	var end = green_zone_start + 10
	if start > end:  # Handle wrapping
		return needle_angle >= start or needle_angle <= end
	else :
		return needle_angle >= start and needle_angle <= end

func print_debug_info():
#	print("Green zone start: ", green_zone_start)
#	print("Green zone size: ", green_zone_size)
#	print("Green zone end: ", green_zone_start + green_zone_size)
	pass

#func _input(event):
	#if is_minigame_active and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
##		print("Player clicked! Needle angle: ", needle_angle)
		#if is_within_green_zone():
			#feedback.text = "Success!"
			#EventHandler.reload_ammo.emit(GlobalVar.weapon_types.MACHINE_GUN)
			#end_minigame()
		#else :
			#feedback.text = "Failed!"
			#end_minigame()
##			print("Click failed! Expected range: ", green_zone_start, " to ", green_zone_start + green_zone_size)
#	pass
