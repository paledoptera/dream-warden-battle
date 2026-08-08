extends Enemy

func check_phase() -> void:
	if turn >= 5:
		goto_next_phase()
