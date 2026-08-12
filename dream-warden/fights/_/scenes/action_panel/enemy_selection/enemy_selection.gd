extends Node2D

signal spawn_menu(menu: PackedScene)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm"):
		spawn_menu.emit(preload("uid://he0wouxpjxmq")) # fight_minigame
		Sound.play(preload("res://shared/sound_effects/snd_select.wav"))
