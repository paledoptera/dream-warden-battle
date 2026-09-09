class_name RudeBusterEffect extends Effect

func apply(user: int, target: int) -> void:
	##var target = Battle.get_target_enemy()
	var hero = Party.get_target_hero(user)
	var enemy = Party.get_target_enemy(target)
	var damage = (float(hero.attack) * 11) + (5 * hero.magic) - (3 * enemy.defense)
	
	var string = "* %s used RUDE BUSTER!"
	var final_string = string % hero.name
	
	Dialogue.display_text(final_string)
	await Dialogue.text_finished
	Dialogue.clear_text.emit()
	
	await Global.get_tree().create_timer(1.0).timeout
	enemy.hp -= damage
	
	effect_applied.emit()
