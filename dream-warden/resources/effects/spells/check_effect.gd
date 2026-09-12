class_name CheckEffect extends Effect


func apply(user: int, target: int) -> void:
	print("CHECK: ", Party.get_target_enemy(target))
	Dialogue.display_text(Party.get_target_enemy(target).check_text)
	await Dialogue.text_finished
	effect_applied.emit()
