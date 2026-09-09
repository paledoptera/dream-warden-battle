class_name StatusFastSoul extends StatusEffect

func on_turn_start(context) -> void:
	Party.soul_speed = 150.0

func on_turn_end(context) -> void:
	Party.soul_speed = Party.DEFAULT_SOUL_SPEED
