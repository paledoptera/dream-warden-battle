class_name Actor extends Node2D

@export var id: StringName = "actor"
var animated_element: Variant
var target: Node2D ## This is for animations like enemy targetting etc

func _ready() -> void:
	EventBus.actor_do_action.connect(_do_action)
	EventBus.actor_trigger_damage_number.connect(_trigger_damage_number)
	EventBus.actor_trigger_effect.connect(_trigger_effect)
	EventBus.actor_set_target.connect(_set_target)
	
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

func _trigger_damage_number(actor_id: StringName, damage_number: FloatingText):
	if actor_id != id:
		return
	
	print(actor_id, " TOOK DAMAGE!")
	
	add_child(damage_number)

func _trigger_effect(actor_id: StringName, effect: PackedScene):
	if actor_id != id:
		return
	
	add_child(effect.instantiate())

func _set_target(actor_id: StringName, target_id: StringName):
	if actor_id != id:
		return
	
	var new_target
	
	for i in get_tree().get_nodes_in_group("actors"):
		if i is not Actor:
			continue
		
		if i.id == target_id:
			new_target = i
			break
	
	if new_target:
		target = new_target
