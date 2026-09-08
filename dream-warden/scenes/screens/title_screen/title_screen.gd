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
			]
		)
	
	if event.is_action_pressed("2"):
		Battle.start(
			[
				preload("uid://drqjfytfhj3kc") # stats_enemy_ice_palace_boss.tres
			],
			preload("uid://ux5c4buxxlkh"), # stage_ice_palace.tscn
			[
				preload("uid://b7i2gw0h2pu35"), # stats_hero_07j_rangle.tres
				preload("uid://bay7e6p8cy1fe"), # stats_hero_07j_chutley.tres
				preload("uid://232nf3wslcjx") # stats_hero_07j_fish.tres
			]
		)
	if event.is_action_pressed("3"):
		SceneLoader.change_scene(preload("uid://ddmjcvocbt7r1"))
