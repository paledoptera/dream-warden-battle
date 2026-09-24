class_name AquaLilypadLayer extends Node2D

@export var travel_time: float = 0.25
@export var up_layer: AquaLilypadLayer
@export var down_layer: AquaLilypadLayer

var lilypads: Array[Node2D]
var current: int = 0


func _ready() -> void:
	for i in get_children():
		lilypads.append(i)
