class_name ConsumableHeal extends ConsumableEffect

@export var heal_amount: int = 50

func do_effect(user : int, used_on : int) -> void:
	EventBus.heal_hero.emit(heal_amount, used_on)
