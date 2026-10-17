class_name AquaLilypadRunaround extends AquaLilypad
@export var speed: float = 1.0


@export var pointer: Node2D
@export var player: Node2D
@export var player_marker: Node2D

var player_angle: float = 0.0
var current: bool = false


func _process(delta: float) -> void:
	var old_current = current
	
	if get_owner().current_lilypad == self:
		current = true
		player_angle = pointer.rotation
		print("PLAYER ANGLE UPDATED TO ", pointer.rotation)
	else:
		pointer.look_at(player.global_position)
		current = false
	
	
	
	if old_current != current:
		old_current = current
		
