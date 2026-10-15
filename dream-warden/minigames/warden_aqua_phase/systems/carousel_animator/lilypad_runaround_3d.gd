class_name LilypadRunaround3D extends Node3D


var lilypad: AquaLilypadRunaround
var runaround_position: float = 0.0
var player_3d: Node3D
@onready var turner: Node3D = $Turner

func _process(delta: float) -> void:
	if not player_3d:
		return
	
	
	if lilypad.current:
		player_3d.set_xz_position(%OffsetPos.global_position)
	else:
		turner.look_at(player_3d.global_position)
