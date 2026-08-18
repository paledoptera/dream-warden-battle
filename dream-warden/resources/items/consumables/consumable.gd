class_name Consumable extends Item

@export var effects: Array[ItemEffect]


func use(user : AbstractFighter, used_on : AbstractFighter) -> void:
	for effect in effects:
		effect.do_effect(user,used_on)
