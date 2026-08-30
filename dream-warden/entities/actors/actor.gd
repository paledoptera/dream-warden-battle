class_name Actor extends Node2D

var id: StringName = "actor"

func _ready() -> void:
	EventBus.actor_do_action.connect(_do_action)

func _do_action(actor_id: StringName, action: StringName):
	if actor_id != id:
		return
	
	$AnimationPlayer.play(action)
