extends TPBar


func _process(delta: float) -> void:
	if Battle.enemy_attacking:
		Battle.tp -= 0.2
	super(delta)
