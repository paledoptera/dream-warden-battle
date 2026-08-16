class_name Check extends SpellEffect

func do_effect(user : AbstractFighter, used_on : AbstractFighter) -> void:
	Dialogue.clear_text.emit()
	Dialogue.display_text.emit(Battle.get_target_enemy().check_text)
	await Dialogue.text_finished
	Battle.goto_next_phase()
