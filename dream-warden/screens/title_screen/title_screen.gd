extends Node2D


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		Battle.start(
			preload("uid://blfmq23jgwm5h") # fight_boss_00_dream_warden
		)
	
	if event.is_action_pressed("2"):
		Battle.start(
			preload("uid://c0veukur2qvwk") # fight_boss_07j_ice_palace_boss
			)
	
	if event.is_action_pressed("3"):
		SceneLoader.change_scene(preload("uid://ddmjcvocbt7r1"))
	
	if event.is_action_pressed("4"):
		Battle.start(
			preload("uid://cq5a5r316rwbs") #fight_boss_08j_varik
		)
