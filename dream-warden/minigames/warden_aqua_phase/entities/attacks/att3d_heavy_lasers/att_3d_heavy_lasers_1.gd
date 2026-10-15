extends Attack3D

@export var amount_of_targets: int = 5
@export var time_in_between: float = 0.6
var targets: Array


func _on_timer_timeout() -> void:
	if not targets:
		targets = carousel_animator.get_children()
		
		for i in targets:
			if not i.lilypad.targetable:
				targets.erase(i)
		
		targets.shuffle()
		targets.resize(amount_of_targets)
	
		
	
	$BulletSpawner3D.global_position = targets.pop_front().global_position
	$BulletSpawner3D.spawn()
	
	if not targets:
		$Timer.stop()
	else:
		$Timer.start(time_in_between)
