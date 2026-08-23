class_name RudeBuster extends SpellEffect

func do_effect(user : AbstractFighter, used_on : AbstractFighter) -> void:
	var target = Battle.get_target_enemy()
	var damage = (float(Battle.heroes[0].attack) * 11) + (5 * Battle.heroes[0].magic) - (3 * target.defense)
	Dialogue.display_text("* Susie used RUDE BUSTER!")
	await Dialogue.text_finished
	
	Dialogue.clear_text.emit()
	
	await Events.get_tree().create_timer(1.0).timeout
	Battle.damage_enemy(damage)
	Battle.goto_next_phase()
