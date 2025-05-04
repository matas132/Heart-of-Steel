class_name DialogicNode_BackgroundHolder
extends ColorRect


func _ready() -> void:
	add_to_group('dialogic_background_holders')
	DialogicUtil.autoload().Text.speaker_updated.connect(on_speaker_updated)



func on_speaker_updated(character: DialogicCharacter)->void:
	if character == null:
		modulate = Color(0.4,0.4,0.4,1)
		return
	
	#print(str(character.get_character_name()))
	if character.get_character_name() != "cmdr_cloake":
		modulate = Color(0.4,0.4,0.4,1)
	else:
		modulate = Color(1,1,1,1)
	
	
#	if get_child_count() >0:
	#	if character.get_character_name() == get_child(0).name:
	#		get_child(0).modulate = Color(1,1,1,1)
	#	else:
	#		get_child(0).modulate = Color(0.4,0.4,0.4,1)
		
	
