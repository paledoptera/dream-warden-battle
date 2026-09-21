extends Node

var actors: Dictionary[StringName,Actor]


func do_action(actor_id: StringName, action: StringName):
	var actor = _find_actor(actor_id)
	if not actor:
		return
	
	actor.do_action(action)


func queue_action(actor_id: StringName, action: StringName):
	var actor = _find_actor(actor_id)
	if not actor:
		return
	
	actor.queue_action(action)


func set_target(actor_id: StringName, target_id: StringName):
	var actor = _find_actor(actor_id)
	var target = _find_actor(target_id)
	if not actor or not target:
		return


func trigger_damage_number(actor_id: StringName, floating_text: FloatingText):
	var actor = _find_actor(actor_id)
	if not actor:
		return
	
	actor.trigger_damage_number(floating_text)


func trigger_effect(actor_id: StringName, effect: PackedScene):
	var actor = _find_actor(actor_id)
	if not actor:
		return
	
	actor.trigger_effect(effect)


func _find_actor(actor_id: StringName) -> Actor:
	if actor_id in actors.keys():
		return actors[actor_id]
	return null


func add_actor(actor_id: StringName, actor: Actor):
	actors[actor_id] = actor


func remove_actor(actor_id: StringName):
	actors.erase(actor_id)
