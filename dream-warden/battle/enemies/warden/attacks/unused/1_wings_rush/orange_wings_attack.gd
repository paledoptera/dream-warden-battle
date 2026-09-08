extends OrangeAttack

@export var spawnpoints: Array[Marker2D]
var current_side = 0
var count = 0

func _ready() -> void:
	super()
	Battle.fight_scene.action_panel.slide_down()

func _on_timer_timeout() -> void:
	count += 1
	var spawnpoint = spawnpoints[current_side]
	
	if count < 5:
		$SideSwapper.scale.x = [-1.0,1.0].pick_random()
		current_side = wrapi(current_side+1,0,2)
		$BulletSpawner.spawn(spawnpoint.global_position,$TrackBullets)
	else:
		count = 0
		current_side = 1
		$DashBulletSpawner.spawn(spawnpoint.global_position, $TrackBullets)
		
	var particle = preload("uid://ccrnhe5x5i131").instantiate()
	$TrackBullets.add_child(particle)
	particle.global_position = spawnpoint.global_position
	particle.emitting = true
	
	
