class_name BattleEventQueue extends Node

signal events_finished

@export var queue: Array[BattleEvent]

func add_event(event: BattleEvent, undo: bool = false):
	queue.append(event)
	
	match event.name:
		"action_defend":
			if not undo:
				var tp_amount = event.data["tp"]
				tp_amount = check_for_tp_overflow(tp_amount)
				EventBus.battle_event.emit("tp_add",tp_amount)
				event.data["tp"] = tp_amount
				
			else:
				var other_event = find_same_event(event)
				EventBus.battle_event.emit("tp_sub",other_event.data["tp"])
				queue.erase(event)
				queue.erase(other_event)
				return
		
		"action_spell":
			if not undo:
				var tp_amount = event.data["tp"]
				EventBus.battle_event.emit("tp_sub",tp_amount)
			else:
				var other_event = find_same_event(event)
				EventBus.battle_event.emit("tp_add",event.data["tp"])
				queue.erase(event)
				queue.erase(other_event)
				return
		
		"action_item":
			if undo:
				var other_event = find_same_event(event)
				queue.erase(event)
				queue.erase(other_event)

func execute_events():
	## NOTE:
	# The default priority for events in EventQueue is this:
	
	# 0 -> DEFEND, TP-generating items or TP consumption.
		# these are a special case which are executed immediately when called.
		# when iterating through these events in execute_events(), they are
		# "finalized" meaning they can't be undone, so they are just deleted
		
	# 1 -> ACT, SPELLS, ITEMS
		# these all exist in the same priority tier, so will just
		# be executed in the order that the actual action commands came
		# all 3 will show text on screen
		# ACT will sometimes spawn a minigame
		
	# 2 -> ATTACKS
		# always comes last
		# will all be consumed into a single minigame
	
	# Keeping a temp version of the queue to use for iteration
	var final_queue: Array[BattleEvent] = queue.duplicate_deep()
	
	final_queue.sort_custom(sort_by_weight)
	
	# This is just to show a legible version of the event queue in print()
	var string: Array[String]
	
	print("")
	print("Final queue is: ", string)
	for i in final_queue:
		print(str(i.name,i.data))
	print("")
	
	# Executing actions
	for event in final_queue:
		var hero_name = Party.hero[event.data["party_member"]].name
		
		match event.name:
			"action_defend":
				continue
			
			"action_spell", "action_act":
				Dialogue.display_text(str("* ", hero_name, " used ", event.data["spell"].title, "!"))
				await Dialogue.text_finished
				continue
			
			"action_item":
				Dialogue.display_text(str("* ", hero_name, " used ", event.data["item"].title, "!"))
				await Dialogue.text_finished
				continue
			
			"action_mercy":
				Dialogue.display_text(str("* ", hero_name, " tried to spare!"))
				await Dialogue.text_finished
				continue
	
	# Executing FIGHT
	var fight_characters = [false,false,false]
	
	for event in final_queue:
		if event.name == "action_fight":
			fight_characters[event.data["party_member"]] = true
		else:
			continue
	
	if true in fight_characters:
		EventBus.battle_event.emit("fight_minigame_start", fight_characters)
	
	# Ending the event queue
	await get_tree().physics_frame
	queue.clear()
	events_finished.emit()

func check_for_tp_overflow(val: int) -> int:
	if Party.tp + val > 100.0:
		val -= ((Party.tp+val)-100.0)
	return val

func sort_by_weight(a, b):
	return a.weight < b.weight

func find_same_event(event:BattleEvent) -> BattleEvent:
	for i in queue:
		if i.name == event.name and \
		i.data["party_member"] == event.data["party_member"]:
			return i
	
	return null
