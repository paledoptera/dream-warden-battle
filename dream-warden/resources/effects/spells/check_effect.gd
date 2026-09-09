class_name CheckEffect extends Effect


func apply(user: int, target: int) -> void:
	Dialogue.display_text(Party.get_target_enemy(target).check_text)
	await Dialogue.text_finished
	effect_applied.emit()
