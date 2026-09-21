class_name UnleashEffect extends Effect

func apply(user: int, target: int) -> void:
	Dialogue.display_text("* Your SOUL emitted a brilliant\n	light!")
	await Dialogue.text_finished
	Actors.trigger_effect("susie",preload("uid://befmcv3nj15yq")) # unleash_effect
	
	EventBus.world_event.emit("enter_parry_mode")
	Dialogue.clear_text.emit()
	await Global.get_tree().create_timer(2.0).timeout
	Party.tp += 80.0
	await Global.get_tree().create_timer(1.0).timeout
	Dialogue.display_text(preload("uid://l45gqd1n64o4")) # dialogue_parry_first
	await Dialogue.text_finished
	Dialogue.clear_text.emit()
	Actors.do_action("susie","axe_powerup")
	await Global.get_tree().create_timer(4.0).timeout
	EventBus.battle_event.emit("replace_tp_bar", preload("uid://b5qm5rv6tx8lt"))
	Dialogue.display_text("* (Susie's AXE began to glow!)")
	await Dialogue.text_finished
	Dialogue.clear_text.emit()
	Flags.story.dream_warden_phase = 1
	effect_applied.emit()
