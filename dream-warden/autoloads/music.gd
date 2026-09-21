extends Node

signal beat

var current_song: String = ""
var enable_rhythm: bool = false
var music: Dictionary[String, AudioStreamPlayer] = {}
var bpm: float = 120.0
var current_position: float = 0.0
var beat_progress: float = 0.0
var last_beat: float = 0.0
var current_beat: float = 0.0
var beat_synced_animations: Array[AnimationPlayer]
var song_synced_animations: Array[AnimationPlayer]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func play(p_music: AudioStream, p_volume := 1.0, start_position := 0.0, p_loop := true, pitch:= 1.0):
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
	audio_player.bus = "Music"
	audio_player.volume_linear = p_volume
	audio_player.pitch_scale = pitch
	audio_player.play(start_position)
	
	current_song = p_music.resource_path

func _process(delta: float) -> void:
	if not enable_rhythm:
		return
	
	var audio: AudioStreamPlayer
	current_position = music[current_song].get_playback_position()
	var sec_per_beat=60.0/bpm
	current_beat = current_position/sec_per_beat

	#print("MUSIC - Current position: ", current_position, " BPM: ", bpm, " Beat: ", current_beat, " Beat progress: ", beat_progress)

	
	if floor(last_beat) != floor(current_beat):
		last_beat = floor(current_beat)
		beat.emit()
		
		#Sound.play(preload("uid://b2asscyml5jh5"))
	
	beat_progress = current_beat-last_beat
	beat_progress = clampf(beat_progress,0.0,1.0)
