extends Node

const TUTORIAL = preload("res://Scenes/TutorialSystem/tutorial.tscn")

func _ready() -> void:
	EventHandler.start_game.connect(on_start_game)

func on_start_game()->void:
	var tut = TUTORIAL.instantiate()
	
	add_child(tut)
