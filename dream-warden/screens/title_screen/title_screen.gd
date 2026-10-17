extends Node

func _ready() -> void:
	$MenuInputManager.open_menu($Options)


func _on_option_selected(index: int) -> void:
	match index:
		0: # Intro cutscene
			SceneLoader.change_scene(preload("uid://cp0mexyia6fo7"))
		1: # Dream warden
			Battle.start(
				preload("uid://blfmq23jgwm5h") # fight_boss_00_dream_warden
			)
		2: # Dream warden parry
			pass
		4: # Dream warden aqua
			SceneLoader.change_scene(SceneLoader.WARDEN_AQUA_PHASE)
		5: # Dream warden final
			pass
		6: # Ice palace boss
			Battle.start(
				preload("uid://c0veukur2qvwk") # fight_boss_07j_ice_palace_boss
			)
		7: # Brother varik
			Battle.start(
				preload("uid://cq5a5r316rwbs") #fight_boss_08j_varik
			)
	pass # Replace with function body.
