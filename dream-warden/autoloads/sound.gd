extends Node

var sounds: Dictionary[String, AudioStreamPlayer] = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func play(p_sound: AudioStream, p_volume := 1.0, pitch:= 1.0, polyphony := 1) -> void:
	var audio_player: AudioStreamPlayer
	
	if !sounds.has(p_sound.resource_path):
		sounds[p_sound.resource_path] = AudioStreamPlayer.new()
		audio_player = sounds[p_sound.resource_path]
		add_child(audio_player)
		
	audio_player = sounds[p_sound.resource_path]
	audio_player.stream = p_sound
	audio_player.volume_linear = p_volume
	audio_player.pitch_scale = pitch
	audio_player.max_polyphony = polyphony
	audio_player.play()
