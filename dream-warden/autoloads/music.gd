extends Node

var current_song: String = ""
var music: Dictionary[String, AudioStreamPlayer] = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func play(p_music: AudioStream, p_volume := 1.0, p_loop := true, pitch:= 1.0):
	var audio_player: AudioStreamPlayer
	
	if p_music.resource_path == current_song:
		return
	
	if !music.has(p_music.resource_path):
		music[p_music.resource_path] = AudioStreamPlayer.new()
		audio_player = music[p_music.resource_path]
		add_child(audio_player)
	
	if p_music is AudioStreamWAV:
		p_music.loop_mode = AudioStreamWAV.LOOP_FORWARD if p_loop else AudioStreamWAV.LOOP_DISABLED
	elif p_music is AudioStreamOggVorbis:
		p_music.loop = p_loop
	
	audio_player = music[p_music.resource_path]
	audio_player.stream = p_music
	audio_player.volume_linear = p_volume
	audio_player.pitch_scale = pitch
	audio_player.play()
	
	current_song = p_music.resource_path
