extends Sprite2D

var base_pos = 86.0
var siner: float = 0.0


func _process(delta: float) -> void:
	siner += delta
	position.y = base_pos + int(Siner.get_sine(siner,3.0,6.0))
