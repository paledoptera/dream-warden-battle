extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self,"scale",Vector2(2.0,0.0),0.4)
	tween.tween_property(self,"modulate",Color(1.0,1.0,1.0,0.0),0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
