class_name DialogueString
extends Resource

@export_multiline var text : String = "* Nothing happened."
@export var require_input: bool = true
@export var auto_skip: bool = false
@export var talksound: AudioStream = preload("res://shared/sound_effects/snd_text.wav")
@export var talksound_oneshot: bool = false
@export_group("Portrait")
@export var portrait: Texture2D
@export var portrait_scale:= Vector2.ONE * 2
@export_group("Markers")
@export var markers: Array[DialogueMarker]
@export_group("Flags")
@export var flag: StringName = ""
@export var flag_value: Variant
@export_group("Identifier")
@export var identifier: StringName = ""

func _init(dialogue_text: String = "") -> void:
	text = dialogue_text
