class_name Hero extends AbstractFighter

signal prism_shield_changed(value: int)

@export var theme_color:= Color.WHITE

var is_defending: bool = false
var prism_shield: int = 0:
	set(value):
		prism_shield = value
		prism_shield_changed.emit(value)
