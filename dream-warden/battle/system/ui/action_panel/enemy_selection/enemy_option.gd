extends SoulSelectableButton

func _on_focus_entered() -> void:
	refresh(get_index())
	super()

func refresh(index: int) -> void:
	var enemy = Party.get_target_enemy(index)
	$Label.text = enemy.name
	$HP/Number.text = str(int(float(enemy.hp) / float(enemy.hp_max)*100.0),"%")
	
	print("enemy = HEALTH ", )
	$HP.value = enemy.hp
	$HP.max_value = enemy.hp_max
	print("enemy = refreshed")
