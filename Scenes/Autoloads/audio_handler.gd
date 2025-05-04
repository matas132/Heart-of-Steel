extends Node

@onready var ui_choose: AudioStreamPlayerLinearVolume = $Choose
@onready var ui_confirm: AudioStreamPlayerLinearVolume = $Confirm

@onready var opening_01: AudioStreamPlayerLinearVolume = $Opening01
@onready var gameplay_01: AudioStreamPlayerLinearVolume = $Gameplay01

@onready var opening_climax: AudioStreamPlayerLinearVolume = $OpeningClimax
@onready var opening_intro: AudioStreamPlayerLinearVolume = $OpeningIntro

@onready var gameplay_combat: AudioStreamPlayerLinearVolume = $GameplayCombat
@onready var gameplay_dialogue: AudioStreamPlayerLinearVolume = $GameplayDialogue

#weapon sound effects
@onready var minigun_fire: RandomSFX = $MinigunFire
@onready var shotgun_fire: RandomSFX = $ShotgunFire
@onready var rocket_fire: AudioStreamPlayerLinearVolume = $RocketFire
@onready var no_ammo_fire: AudioStreamPlayerLinearVolume = $NoAmmoFire

#weapon reloads
@onready var minigun_reload_failure: AudioStreamPlayerLinearVolume = $Reload/MinigunReload/MinigunReloadFailure
@onready var minigun_reload_succes: AudioStreamPlayerLinearVolume = $Reload/MinigunReload/MinigunReloadSucces

@onready var shotgun_reload_grab: AudioStreamPlayerLinearVolume = $Reload/ShotgunReload/ShotgunReloadGrab
@onready var shotgun_reload_engage: AudioStreamPlayerLinearVolume = $Reload/ShotgunReload/ShotgunReloadEngage
@onready var shotgun_reload_success: AudioStreamPlayerLinearVolume = $Reload/ShotgunReload/ShotgunReloadSuccess

@onready var rocket_reload_failure: AudioStreamPlayerLinearVolume = $Reload/RocketReload/RocketReloadFailure
@onready var rocket_reload_success: AudioStreamPlayerLinearVolume = $Reload/RocketReload/RocketReloadSuccess


@onready var weapon_select: RandomSFX = $WeaponSelect


@onready var title: AudioStreamPlayerLinearVolume = $Title


@onready var self_destruct: AudioStreamPlayerLinearVolume = $SelfDestruct


@onready var radio: AudioStreamPlayerLinearVolume = $Radio
@onready var death: AudioStreamPlayerLinearVolume = $Death


const VERY_SHORT_LERP_TIME := 1.0


enum MUSIC{
	OPENING,
	GAMEPLAY,
	
}

signal sound_finished

func start_sound_with_signal(sound)->void:
	sound.play()
	await sound.finished
	sound_finished.emit()



@onready var music = {
	MUSIC.OPENING: opening_01,
	MUSIC.GAMEPLAY: gameplay_01,
	
}

func stop_all_sounds()->void:
	for child in get_children():
		if child is AudioStreamPlayer:
			child.stop()


func play_music(music_enum: MUSIC,pos : float = 0.0)->void:
	
	music[music_enum].play(pos)
	music[music_enum].volume_level = 1.0
	
func stop_music(music_enum: MUSIC)->void:
	music[music_enum].stop()




func start_dialogue_music()->void:
	lerp_from_none_to_max(gameplay_dialogue)

func end_dialogue_music()->void:
	lerp_to_none(gameplay_dialogue)


func start_gameplay_music()->void:
	lerp_from_none_to_max(gameplay_combat)

func end_gameplay_music()->void:
	lerp_to_none(gameplay_combat)




# methods

# slowly transitions the specified sound to the specified volume, the volume must be linear
func lerp_to_specific_volume(sound: AudioStreamPlayerLinearVolume, specific_volume_level: float, lerp_time: float = VERY_SHORT_LERP_TIME) ->void:
	sound.hidden = false
	if !sound.playing:
		sound.play()
	var tween = get_tree().create_tween()
	tween.tween_property(sound, "volume_level",specific_volume_level,lerp_time)

func lerp_to_specific_volume_mult(sound: AudioStreamPlayerLinearVolume, specific_volume_mult: float, lerp_time: float = VERY_SHORT_LERP_TIME) ->void:
	var tween = get_tree().create_tween()
	tween.tween_property(sound, "volume_mult",specific_volume_mult,lerp_time)




# 
func lerp_to_none(sound: AudioStreamPlayerLinearVolume) ->void:
	sound.hidden = true
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(sound, "volume_level",0.001,VERY_SHORT_LERP_TIME)
	await tween.finished
	sound.stop()

func lerp_from_none_to_max(sound : AudioStreamPlayerLinearVolume, lerp_time: float = VERY_SHORT_LERP_TIME) ->void: # sets the sounds volume db from 0 to 1
	sound.hidden = false
	sound.volume_level = 0.001
	
	
	if !sound.playing:
		sound.play()
	lerp_to_specific_volume(sound, 1, lerp_time)
	
	
	

func secretly_play_sound(sound: AudioStreamPlayerLinearVolume) ->void:
	sound.volume_level = 0.001
	sound.hidden = true
	
	
	if !sound.playing:
		sound.play()

func lerp_to_secretly_none(sound: AudioStreamPlayerLinearVolume) ->void: # lowers it to 0 but doesn't turn it off so its syncronised
	sound.hidden = true
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(sound, "volume_level",0.001,VERY_SHORT_LERP_TIME)
