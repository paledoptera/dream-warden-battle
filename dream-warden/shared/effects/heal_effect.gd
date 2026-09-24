class_name HealEffect extends Effect

@export var amount: int = 10

func apply(_user: int, target: int) -> void:
	await Party.get_tree().create_timer(0.2).timeout
	heal(target)
	Sound.play(preload("uid://dn6sygxxt1y8u"))
	await Party.get_tree().physics_frame
	effect_applied.emit()


func heal(target: int) -> void:
	match target:
		Enums.Target.HERO:
			var hero = Party.get_target_hero(target)
			hero.hp += amount
			var text
			if hero.hp >= hero.hp_max:
				text = FloatingText.initialize_sprite(preload("uid://dxq5r7hqpxns6"),Vector2.ZERO,Color.GREEN)
			else:
				text = FloatingText.initialize_text(str(amount),Color.GREEN)
			Actors.trigger_damage_number(hero.character_id,text)
			
		Enums.Target.ALL_HEROES:
			for i in Party.hero:
				i.hp += amount
		
		Enums.Target.ENEMY:
			Party.get_target_enemy(target).hp += amount
		
		Enums.Target.ALL_ENEMIES:
			for i in Party.enemy:
				i.hp += amount
