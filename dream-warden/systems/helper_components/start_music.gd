class_name StartMusic extends Node

@export var song: AudioStream

func _ready() -> void:
	Music.play(song)
