class_name StatusFastSoul extends StatusEffect

func on_turn_start(context) -> void:
	Flags.battle.soul_speed = 150.0
