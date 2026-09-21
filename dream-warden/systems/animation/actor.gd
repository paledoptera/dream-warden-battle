class_name Actor extends Node2D

@export var id: StringName = "actor"
var animated_element: Variant
var target: Node2D ## This is for animations like enemy targetting etc
var action_queue: Array[StringName]

func _ready() -> void:
	for i in get_children():
		if i is AnimationPlayer:
			animated_element = i
			i.animation_finished.connect(_action_finished)
			break
		elif i is AnimatedSprite2D:
			animated_element = i
			break


func _enter_tree() -> void:
	Actors.add_actor(id,self)


func _exit_tree() -> void:
	Actors.remove_actor(id)


func do_action(action: StringName):
	if animated_element:
		animated_element.play(action)


func queue_action(action: StringName):
	print("ACTION QUEUED", action)
	action_queue.append(action)
	print("ACTION QUEUE: ", action_queue)


func trigger_damage_number(damage_number: FloatingText):
	add_child(damage_number)


func trigger_effect(effect: PackedScene):
	add_child(effect.instantiate())


func set_target(new_target: Actor):
	if new_target:
		target = new_target


func _action_finished(action_name: StringName):
	if not action_queue or not animated_element:
		print("ACTION QUEUE: ", action_queue)
		return
	
	animated_element.play(action_queue.pop_front())
