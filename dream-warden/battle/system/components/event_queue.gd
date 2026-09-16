class_name BattleEventQueue extends Node

signal events_finished

@export var queue: Array[BattleEvent]

func add_event(event: BattleEvent, undo: bool):
	queue.append(event)
	
	print("EVENT: ", event, " TYPE: ", event.action_type, " UNDO: ", undo, " CHARACTER: ", event.character)
	
	
	do_actor_animation(event, undo)
	
	
	match event.action_type:
		BattleEvent.Type.DEFEND:
			if undo == false:
				var tp_amount = event.data["tp"]
				tp_amount = check_for_tp_overflow(tp_amount)
				EventBus.battle_event.emit("tp_add",tp_amount)
				event.data["tp"] = tp_amount
			elif undo == true:
				print("FUCK")
				var other_event = find_same_event(event)
				EventBus.battle_event.emit("tp_sub",other_event.data["tp"])
				queue.erase(event)
				queue.erase(other_event)
				return
		
		BattleEvent.Type.MAGIC:
			if not undo:
				var tp_amount = event.data["tp"]
				EventBus.battle_event.emit("tp_sub",tp_amount)
			else:
				var other_event = find_same_event(event)
				EventBus.battle_event.emit("tp_add",event.data["tp"])
				queue.erase(event)
				queue.erase(other_event)
				return
		
		BattleEvent.Type.ITEM:
			if not undo:
				PlayerInventory.items.erase(event.data["item"])
			else:
				var other_event = find_same_event(event)
				PlayerInventory.items.insert(0,other_event.data["item"])
				queue.erase(event)
				queue.erase(other_event)
		
		BattleEvent.Type.FIGHT, BattleEvent.Type.MERCY:
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
	
	
	var final_queue: Array[BattleEvent] = queue.duplicate(true)
	
	final_queue.sort_custom(sort_by_priority)
	
	# This is just to show a legible version of the event queue in print()
	var string: Array[String]
	
	print("")
	print("Final queue is: ", string)
	for i in final_queue:
		print(str(i.Type.keys()[i.action_type],i.data))
	print("")
	
	# Executing actions
	for event in final_queue:
		var hero_name = Party.hero[event.character].name
		
		match event.action_type:
			BattleEvent.Type.DEFEND:
				continue
			
			BattleEvent.Type.MAGIC:
				print("DOING SPELL")
				var spell = event.data["spell"]
				spell.use(event.character, event.target)
				
				await spell.finished
				
				if not spell.handles_dialogue_box:
					print("NEEDS DIALOGUE")
					Dialogue.display_text(str("* ", hero_name, " used ", event.data["spell"].name, "!"))
					await Dialogue.text_finished
				continue
			
			BattleEvent.Type.ITEM:
				print("USING ITEM")
				var item = event.data["item"]
				item.use(event.character, event.target)
				Dialogue.display_text(str("* ", hero_name, " used ", event.data["item"].name, "!"))
				await Dialogue.text_finished
				continue
			
			BattleEvent.Type.MERCY:
				var enemy = Party.get_target_enemy(event.target)
				if enemy.spareable:
					Party.enemy.erase(enemy)
				else:
					print("ENEMY IS NOT SPAREABLE")
					Dialogue.display_text(enemy.mercy_fail_text)
				await Dialogue.text_finished
				continue
	
	# Executing FIGHT
	var fight_characters = [false,false,false]
	var fight_targets = [0,0,0]
	
	for event in final_queue:
		if event.action_type == BattleEvent.Type.FIGHT:
			fight_characters[event.character] = true
			fight_targets[event.character] = event.target
		else:
			continue
	
	if true in fight_characters:
		EventBus.enter_fight_minigame.emit(fight_characters,fight_targets)
	
	await get_tree().physics_frame
	events_finished.emit()
	print("EVENTS FINISHED")
	queue.clear()

func check_for_tp_overflow(val: int) -> int:
	if Party.tp + val > 100.0:
		val -= ((Party.tp+val)-100.0)
	return val

func sort_by_priority(a, b):
	return a.priority < b.priority

func find_same_event(event:BattleEvent) -> BattleEvent:
	for i in queue:
		if i.action_type == event.action_type and \
		i.character == event.character:
			return i

	return null


func do_actor_animation(event: BattleEvent, undo: bool) -> void:
	
	var party_member = Party.get_target_hero(event.character)
	var action_name: StringName = "idle"
	
	if not undo:
		match event.action_type:
			BattleEvent.Type.FIGHT:
				action_name = "fight_prepare"
			BattleEvent.Type.DEFEND:
				action_name = "defend"
			BattleEvent.Type.MAGIC:
				action_name = "magic_prepare"
		
	
	EventBus.actor_do_action.emit(party_member.character_id, action_name)
