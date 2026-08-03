extends BulletSpawner
class_name OrangeBulletSpawner

## Spawns bullets based on distance orange soul travels


@export var track_bullets: Node2D
@export var distance_interval: float = 1000.0
@export var spawnpoints: Array[Marker2D]

var target: float = 0.0
func _process(delta: float) -> void:
	if target < Battle.soul.distance:
		target += distance_interval
		if target == distance_interval:
			return
		spawn(spawnpoints.pick_random().global_position,track_bullets)
