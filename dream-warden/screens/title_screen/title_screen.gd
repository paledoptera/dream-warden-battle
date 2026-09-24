extends Node

func _ready() -> void:
	$MenuInputManager.open_menu($Options)


func _on_option_selected(index: int) -> void:
	match index:
		0: # Dream warden
			Battle.start(
				preload("uid://blfmq23jgwm5h") # fight_boss_00_dream_warden
			)
		1: # Dream warden parry
			pass
		2: # Dream warden aqua
			SceneLoader.change_scene(SceneLoader.WARDEN_AQUA_PHASE)
		3: # Dream warden final
			pass
		4: # Ice palace boss
			Battle.start(
				preload("uid://c0veukur2qvwk") # fight_boss_07j_ice_palace_boss
			)
		5: # Brother varik
			Battle.start(
				preload("uid://cq5a5r316rwbs") #fight_boss_08j_varik
			)
		6: # Here come the cats
			SceneLoader.change_scene(preload("uid://ddmjcvocbt7r1"))
	pass # Replace with function body.
