extends Node2D

@export var text: RichTextLabel


func _process(delta: float) -> void:
	if text.visible:
		visible = true
	else:
		visible = false
	pass
