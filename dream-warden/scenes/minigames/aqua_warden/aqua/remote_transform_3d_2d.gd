extends Node3D
class_name RemoteTransform3D2D

@export var node: Node2D
@export var x_enabled: bool = true
@export var y_enabled: bool = true
@export var offset:= Vector2.ZERO
@export var res_scale: float = 1.0

func _process(delta: float) -> void:
	var new_pos = get_viewport().get_camera_3d().unproject_position(global_position)
	new_pos *= res_scale
	if x_enabled:
		node.global_position.x = new_pos.x + offset.x
	if y_enabled:
		node.global_position.y = new_pos.y + offset.y
