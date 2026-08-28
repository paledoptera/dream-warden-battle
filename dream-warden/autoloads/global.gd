extends Node

signal tp_changed(value: float)

var tp: float = 0.0:
	set(value):
		tp_changed.emit(value)
		tp = value

func _ready() -> void:
	prepare_menu()

func prepare_menu() -> void:
	Menu.set_sounds(
		preload("res://shared/sound_effects/snd_menumove.wav"),
		preload("res://shared/sound_effects/snd_select.wav")
		)
