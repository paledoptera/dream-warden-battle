extends Node2D
@export var gonermaker_template: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var inst = gonermaker_template.duplicate()
	var tween = create_tween()
	var tween2 = create_tween()
	add_child(inst)
	
	tween.tween_property(inst,"modulate",Color("ffffffa3"),1.25)
	tween.parallel().tween_property(inst,"scale",Vector2(4.0,4.0),5.0)
	
	
	tween2.tween_interval(3.0)
	tween2.tween_property(inst,"modulate",Color("ffffff00"),1.25)
	tween2.tween_callback(inst.queue_free)
	pass # Replace with function body.
