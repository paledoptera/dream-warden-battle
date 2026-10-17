extends Node3D

var origin: Node3D
var target: Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = origin.global_position
	look_at(target.global_position)
