class_name ItemHeal extends ItemEffect

@export var heal_amount: int = 50

func do_effect(user : AbstractFighter, used_on : AbstractFighter) -> void:
	Battle.heal_hero(heal_amount, 0)
