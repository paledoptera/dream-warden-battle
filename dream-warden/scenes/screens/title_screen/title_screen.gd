extends Node2D


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		Battle.start(
			[
				preload("uid://dsnpoy8ro5it6") # stats_enemy_warden.tres
			],
			preload("uid://c0r0lc0kwmgif"), # stage_warden.tscn
			[
				preload("uid://b43pqrbag27nj"), # stats_hero_susie.tres
				preload("uid://b43pqrbag27nj"), # stats_hero_susie.tres
				preload("uid://b43pqrbag27nj"), # stats_hero_susie.tres
			]
		)
