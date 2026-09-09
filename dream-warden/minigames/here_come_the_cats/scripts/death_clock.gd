extends Node2D



func _on_conducted_timer_timeout() -> void:
	$Sprite2D.rotate(deg_to_rad(4.5))
	Sound.play(preload("uid://dqdqlcl363j8h"),1.0)
