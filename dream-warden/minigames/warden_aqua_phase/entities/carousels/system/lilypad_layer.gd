class_name AquaLilypadLayer extends Node2D

@export var travel_time: float = 0.25
@export var up_layer: AquaLilypadLayer
@export var down_layer: AquaLilypadLayer
@export var enabled: bool = false: set = _set_enabled

var lilypads: Array[Node2D]
var current: int = 0


func _ready() -> void:
	for i in get_children():
		lilypads.append(i)

func _set_enabled(value: bool):
	enabled = value
	if get_owner():
		
		get_owner().lilypad_layer_changed_state.emit(self,value)
	
	if get_children():
		for i in get_children():
			i.active = value
	
