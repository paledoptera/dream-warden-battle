class_name BattleEventQueue extends Node

@export var queue: Array[BattleEvent]

func add_event(event: BattleEvent, undo: bool = false):
	queue.append(event)
	
	match event.name:
		"action_defend":
			if not undo:
				var tp_amount = event.data["tp"]
				EventBus.battle_event.emit("tp_add",event.data["tp"])
				
			else:
				
				EventBus.battle_event.emit("tp_sub",event.data["tp"])
				queue.erase(event)
				return

func execute_event():
	pass
