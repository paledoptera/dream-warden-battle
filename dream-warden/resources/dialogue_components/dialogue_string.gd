class_name DialogueString
extends Resource

@export_multiline var text : String = "* Nothing happened."
@export var require_input: bool = true
@export var talksound: AudioStream = preload("res://shared/sound_effects/snd_text.wav")
@export_group("Portrait")
@export var portrait: Texture2D
@export var portrait_scale:= Vector2.ONE * 2
@export_group("Markers")
@export var markers: Array[DialogueMarker]
@export_group("Flags")
@export var flag: StringName = ""
@export var flag_value: Variant
