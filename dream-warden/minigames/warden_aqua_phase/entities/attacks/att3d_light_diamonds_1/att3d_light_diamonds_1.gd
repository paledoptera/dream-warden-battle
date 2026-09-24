extends Attack3D

var count: int = 0
	
func _on_timer_timeout() -> void:
	aim($BulletSpawner3D, get_player_lilypad())
	$BulletSpawner3D.spawn()

	aim($BulletSpawner3D, get_left_lilypad())
	$BulletSpawner3D.spawn()

	aim($BulletSpawner3D, get_right_lilypad())
	$BulletSpawner3D.spawn()

	boss_aim_at.emit(get_player_lilypad())
	
	Sound.play(preload("res://shared/sound_effects/snd_wingslash.wav"),0.7,randf_range(0.9,1.2))
	count += 1
	
	if count >= 3:
		$Timer.stop()
