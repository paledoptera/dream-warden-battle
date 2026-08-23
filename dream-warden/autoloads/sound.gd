extends Node

var mono_sounds: Dictionary[String, AudioStreamPlayer] = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func play(p_sound: AudioStream, p_volume := 1.0, pitch:= 1.0, polyphony := true) -> void:
	var audio_player: AudioStreamPlayer
	
	if not polyphony:
		if !mono_sounds.has(p_sound.resource_path):
			mono_sounds[p_sound.resource_path] = AudioStreamPlayer.new()
			audio_player = mono_sounds[p_sound.resource_path]
			add_child(audio_player)
		else:
			mono_sounds[p_sound.resource_path].play()
			return
	else:
		audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
	
	audio_player.stream = p_sound
	audio_player.volume_linear = p_volume
	audio_player.pitch_scale = pitch
	audio_player.play()
