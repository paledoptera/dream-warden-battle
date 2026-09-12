class_name DamageEffect extends Effect

@export var amount: int = 10

func apply(_user: int, target: int) -> void:
	damage(target)
	await Party.get_tree().physics_frame
	effect_applied.emit()

func damage(target: int) -> void:
	match target:
		Enums.Target.HERO:
			Party.get_target_hero(target).hp -= amount
		
		Enums.Target.ALL_HEROES:
			for i in Party.hero:
				i.hp -= amount
		
		Enums.Target.ENEMY:
			Party.get_target_enemy(target).hp -= amount
		
		Enums.Target.ALL_ENEMIES:
			for i in Party.enemy:
				i.hp -= amount
