class_name ItemTP extends ConsumableEffect

@export var tp_amount: int = 16

func do_effect(user : int, used_on : int) -> void:
	EventBus.battle_tp_add.emit(tp_amount)
