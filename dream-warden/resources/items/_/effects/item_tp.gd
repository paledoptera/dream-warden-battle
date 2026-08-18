class_name ItemTP extends ItemEffect

@export var tp_amount: int = 16

func do_effect(user : AbstractFighter, used_on : AbstractFighter) -> void:
	Battle.tp += tp_amount
