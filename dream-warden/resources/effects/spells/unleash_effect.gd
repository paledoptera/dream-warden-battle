class_name UnleashEffect extends Effect

func apply(user: int, target: int) -> void:
	Dialogue.display_text("* Your SOUL emitted a brilliant\n	light!")
	await Dialogue.text_finished
	Party.tp = 100.0
	EventBus.world_event.emit("enter_parry_mode")
	Dialogue.clear_text.emit()
	await Global.get_tree().create_timer(1.0).timeout
	effect_applied.emit()
