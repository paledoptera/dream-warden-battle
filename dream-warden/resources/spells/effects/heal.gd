class_name Heal extends SpellEffect

@export var heal_amount: int = 90

func do_effect(user : AbstractFighter, used_on : AbstractFighter) -> void:
	pass
	#Battle.heal_hero(heal_amount)
	#Battle.goto_next_phase()
