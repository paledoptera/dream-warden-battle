extends Attack3D

var count: int = 0

func _on_timer_timeout() -> void:
	$BulletSpawner3DMega.spawn($BulletSpawner3DMega.global_position,get_player_lilypad().global_position)

	boss_aim_at.emit(get_player_lilypad())
	
	Sound.play(preload("res://shared/sound_effects/snd_wingslash.wav"),0.7,randf_range(0.9,1.2))
	count += 1
	
	if count >= 2:
		$Timer.stop()
