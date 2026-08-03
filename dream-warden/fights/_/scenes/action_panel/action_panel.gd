extends Node2D

@export var actions: Node2D

func slide_down() -> Tween:
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(position.x,481.0),0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	return tween


func hide_health() -> void:
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(0.0,520.0),0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
