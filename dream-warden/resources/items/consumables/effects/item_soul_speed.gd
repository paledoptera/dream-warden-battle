class_name ItemSoulSpeed extends ConsumableEffect

@export var soul_speed: float = 120.0

func do_effect(user : int, used_on : int) -> void:
	EventBus.battle_flag_update.emit("soul_speed", soul_speed)
