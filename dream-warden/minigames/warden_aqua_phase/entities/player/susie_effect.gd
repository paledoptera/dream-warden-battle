extends Sprite3D

func _process(delta: float) -> void:
	frame_coords = get_parent().frame_coords
	flip_h = get_parent().flip_h
