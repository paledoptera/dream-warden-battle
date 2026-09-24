extends Attack3D

var targets: Array

func _on_timer_timeout() -> void:
	if not targets:
		targets = carousel_animator.get_children()
		targets.shuffle()
		targets.resize(4)
	
	$BulletSpawner3D.global_position = targets.pop_front().global_position
	$BulletSpawner3D.spawn()
	
	if not targets:
		$Timer.stop()
	else:
		$Timer.start(0.6)
