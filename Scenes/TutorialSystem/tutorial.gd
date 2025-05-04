extends Control


@onready var _1: TextureRect = $"CanvasLayer/1"
@onready var _2: TextureRect = $"CanvasLayer/2"
@onready var _3: TextureRect = $"CanvasLayer/3"
@onready var _4: TextureRect = $"CanvasLayer/4"
@onready var _5: TextureRect = $"CanvasLayer/5"
@onready var _6: TextureRect = $"CanvasLayer/6"
@onready var _7: TextureRect = $"CanvasLayer/7"


@onready var tutorial_images =[ _1, _2, _3, _4, _5, _6, _7 ]




var clicks := 0

var current_image 

var ready_for_tutorial := false


func _ready() -> void:
	get_tree().paused = true
	clicks = 0
	current_image = tutorial_images[clicks] as TextureRect
	current_image.visible = true
	await get_tree().create_timer(1.7,true).timeout
	ready_for_tutorial = true


func _input(event: InputEvent) -> void:
	if ready_for_tutorial:
		if event.is_action_pressed("left_click"):
			on_pressed()


func on_pressed() -> void:
	current_image.visible = false
	if clicks < tutorial_images.size()-1:
		clicks+=1
		current_image = tutorial_images[clicks] as TextureRect
		current_image.visible = true
		
		ready_for_tutorial = false
		await get_tree().create_timer(0.8,true).timeout
		ready_for_tutorial = true
	else:
		get_tree().paused = false
		queue_free()
	
