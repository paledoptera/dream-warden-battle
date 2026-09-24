extends Node3D
class_name RemoteTransform3D2D

@export var source: Node3D
@export var node: Node
@export var x_enabled: bool = true
@export var y_enabled: bool = true
@export var offset:= Vector2.ZERO
@export var res_scale: float = 1.0

func update_position() -> void:
	var new_pos = source.get_viewport().get_camera_3d().unproject_position(source.global_position)
	new_pos *= res_scale
	if x_enabled:
		node.global_position.x = new_pos.x + offset.x
	if y_enabled:
		node.global_position.y = new_pos.y + offset.y
