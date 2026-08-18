class_name ItemSoulSpeed extends ItemEffect

@export var soul_speed: float = 120.0

func do_effect(user : AbstractFighter, used_on : AbstractFighter) -> void:
	Battle.soul_speed = soul_speed
