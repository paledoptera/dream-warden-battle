extends Node

func _ready() -> void:
	prepare_menu()

func prepare_menu() -> void:
	Menu.set_sounds(
		preload("res://shared/sound_effects/snd_menumove.wav"),
		preload("res://shared/sound_effects/snd_select.wav")
		)
