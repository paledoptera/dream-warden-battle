extends Attack3D

@export var amount_of_bullets: int = 5
@export var time_in_between: float = 0.3

var targets: Array
var origins: Array



func _ready() -> void:
	for i in $ElectroCarousel.get_children():
		targets.append(i.get_child(0))
	for i in $ElectroCarousel2.get_children():
		origins.append(i.get_child(0))

func _on_timer_timeout() -> void:
	var targets_final = targets.duplicate()
	var origins_final = origins.duplicate()
	
	targets_final.shuffle()
	origins_final.shuffle()
	
	var origin = origins_final.pop_front()
	var target = targets_final.pop_front()
	
	$BulletSpawner3D.global_position = origin.global_position
	var bullet = $BulletSpawner3D.spawn()
	bullet.origin = origin
	bullet.target = target

	amount_of_bullets -= 1
	if amount_of_bullets <= 0:
		$Timer.stop()
	else:
		$Timer.start(time_in_between)
