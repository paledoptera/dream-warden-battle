class_name Actor extends Node2D

@export var id: StringName = "actor"
var animated_element: Variant

func _ready() -> void:
	EventBus.actor_do_action.connect(_do_action)
	
	
	for i in get_children():
		if i is AnimationPlayer:
			animated_element = i
			break
		elif i is AnimatedSprite2D:
			animated_element = i
			break
	



func _do_action(actor_id: StringName, action: StringName):
	if actor_id != id:
		return
	
	if animated_element:
		animated_element.play(action)
