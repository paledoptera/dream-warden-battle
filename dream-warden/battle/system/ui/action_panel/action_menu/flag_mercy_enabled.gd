extends FlagConditional


func flag_equals_value() -> void:
	get_parent().frame_coords.y = 2
	if Menu.current_menu == get_owner():
		Menu.disabled_options = [3]

func flag_not_value() -> void:
	pass
