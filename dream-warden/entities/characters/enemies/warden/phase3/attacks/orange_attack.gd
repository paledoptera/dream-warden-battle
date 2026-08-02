extends Node2D
@export var soul: SoulOrange

func _process(delta: float) -> void:
	var speed = soul.orange_velocity
	$Track.global_position += speed * delta
	$OrangeTrack.scroll_offset += speed * delta
