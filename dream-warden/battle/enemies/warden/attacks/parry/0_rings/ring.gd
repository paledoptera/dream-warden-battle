extends Sprite2D


func _process(delta: float) -> void:
	if scale <= Vector2(0.1,0.1):
		queue_free()
