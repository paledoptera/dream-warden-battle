extends Node2D


func _process(delta: float) -> void:
	var movement = Battle.soul.global_position - Battle.soul.last_position
	
	if not $Bullet/CollisionShape2D:
		queue_free()
		return
	if sign(movement.x) == -sign(scale.x):
		$Bullet/CollisionShape2D.disabled = true
	else:
		$Bullet/CollisionShape2D.disabled = false
