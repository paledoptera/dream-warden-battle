class_name AddStatusEffect extends Effect

@export var status: StatusEffect


func apply(_user: int, target: int) -> void:
	add_status(target)
	effect_applied.emit()

func add_status(target: int) -> void:
	var status_inst = status.duplicate(true)
	status_inst.resource_local_to_scene = true
	
	match target:
		Enums.Target.HERO:
			Party.get_target_hero(target).status_effects.append(status_inst)
		
		Enums.Target.ALL_HEROES:
			for i in Party.hero:
				i.status_effects.append(status_inst)
		
		Enums.Target.ENEMY:
			Party.get_target_enemy(target).status_effects.append(status_inst)
		
		Enums.Target.ALL_ENEMIES:
			for i in Party.enemy:
				i.status_effects.append(status_inst)
