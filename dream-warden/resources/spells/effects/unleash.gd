class_name Unleash extends SpellEffect

func do_effect(user : AbstractFighter, used_on : AbstractFighter) -> void:
	Dialogue.display_text("* Your SOUL emitted a brilliant\n	light!")
	await Dialogue.text_finished
	Battle.tp = 100.0
	Events.play_animation.emit("unleash")
	Events.world_event.emit("enter_parry_mode")
	Dialogue.clear_text.emit()
	
	await Events.get_tree().create_timer(1.0).timeout
	Battle.goto_next_phase()
