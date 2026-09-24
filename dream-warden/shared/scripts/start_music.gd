class_name StartMusic extends Node

@export var song: AudioStream
@export var bpm: float = 120.0
@export var start_position: float = 0.0
@export var enable_rhythm_tracking: bool = false

func _ready() -> void:
	Music.bpm = bpm
	Music.enable_rhythm = enable_rhythm_tracking
	Music.play(song,1.0,start_position)
