#Hacky sound effect system

extends Node2D

func play_sound(sound:String):
	var audio_player = get_node_or_null(sound)
	if audio_player != null:
		audio_player.play()
	else:
		print("Invalid sound: ", sound)
	pass
