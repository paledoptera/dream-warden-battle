extends Node2D

var timer = 1.0
var count = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_laser(sound: bool = false) -> void:
	var laser = preload("uid://qopiw1dcf4qu").instantiate()
	$Battlebox.add_child(laser)
	var target = $Target1.get_children().pick_random()
	laser.sound_enabled = sound
	laser.start_pos = target
	laser.end_pos = $Target2.get_child(target.get_index())

func _on_timer_timeout() -> void:
	count += 1 
	print(count)
	create_laser(true)
	await get_tree().create_timer(0.1).timeout
	create_laser(false)
	await get_tree().create_timer(0.1).timeout
	create_laser(false)
	await get_tree().create_timer(0.9* (timer / 2.0)).timeout
	
	
	
	timer -= 0.15
	timer = max(timer,0.2)
	%BulletSpawnerMega.speed_mult += 0.2
	%BulletSpawnerMega.look_at($SoulParry.global_position)
	$Sprite2D/BulletSpawnerMega.spawn()
	await get_tree().create_timer(0.4 * (timer/2.0)).timeout
	%BulletSpawnerMega.look_at($SoulParry.global_position)
	$Sprite2D/BulletSpawnerMega.spawn()
	await get_tree().create_timer(0.3 * (timer/2.0)).timeout
	%BulletSpawnerMega.look_at($SoulParry.global_position)
	$Sprite2D/BulletSpawnerMega.spawn()
	
	if count < 6:
		$Sprite2D/BulletSpawnerMega/Timer.start(timer)
	else:
		var laser = preload("uid://bx1dt60ld4oiy").instantiate()
		$Battlebox.add_child(laser)
		laser.start_pos = $MegaLaserTarget1
		laser.end_pos = $MegaLaserTarget2
		
	pass # Replace with function body.
