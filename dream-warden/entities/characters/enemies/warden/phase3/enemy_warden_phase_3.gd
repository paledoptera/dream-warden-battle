extends Enemy

func check_phase() -> void:
	if turn >= 2:
		goto_next_phase()
	## put a conditional to goto_next_phase here if you want a multi-phase enemy/boss
	pass
