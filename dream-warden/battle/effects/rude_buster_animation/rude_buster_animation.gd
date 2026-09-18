extends Node2D

const AFTERIMAGE = preload("uid://bxr0vym0d4gf")
var time: float = 0.0

func set_target(node2d: Node2D) -> void:
	
	$Path2D.curve.add_point($Path2D.to_local(node2d.global_position))

func _physics_process(delta: float) -> void:
	if time >= 0.4333:
		return
	
	var afterimage = AFTERIMAGE.instantiate()
	afterimage.modulate = %Buster.modulate
	add_child(afterimage)
	afterimage.global_position = %Buster.global_position
	afterimage.global_rotation = %Buster.global_rotation
	
	time += delta
