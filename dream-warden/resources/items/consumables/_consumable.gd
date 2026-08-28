class_name Consumable extends Item

@export var effects: Array[ConsumableEffect]

func use(user : int, used_on : int) -> void:
	for effect in effects:
		effect.do_effect(user,used_on)
