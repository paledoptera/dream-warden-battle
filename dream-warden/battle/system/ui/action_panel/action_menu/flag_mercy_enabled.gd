extends FlagConditional

@export var sprite: Sprite2D

func flag_equals_value() -> void:
	sprite.frame_coords.y = 2
	get_parent().disabled = true
	if get_parent().is_in_group("menu_option"):
		get_parent().remove_from_group("menu_option")
	get_parent().focus_mode = Control.FOCUS_NONE

func flag_not_value() -> void:
	pass
