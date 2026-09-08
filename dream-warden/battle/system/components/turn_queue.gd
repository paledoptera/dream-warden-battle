extends Node

signal turn_started(index: int)
signal turn_finished(index: int)
signal all_turns_finished

var index: int = 0
var active_character: Node


func build_queue() -> void:
	for i in get_children():
		i.action = null
	
	index = 0
	active_character = get_child(index)
	
	var size: int = 0
	
	play_turn()

func play_turn():
	if not active_character:
		return
	var current_active = active_character
	print("TURN START ", active_character)
	turn_started.emit(index)
	active_character.play_turn()
	
	await active_character.turn_finished
	await get_tree().process_frame
	
	if active_character != current_active:
		return # turn was cancelled
	
	var new_index = (active_character.get_index() + 1)
	turn_finished.emit(index)
	
	if not new_index >= get_child_count():
		if not get_child(new_index).can_take_turn():
			while new_index < get_child_count():
				if get_child(new_index).can_take_turn():
					break
				new_index += 1

	if new_index >= get_child_count():
		active_character = null
		index = -1
		all_turns_finished.emit()
		return
	
	active_character = get_child(new_index)
	index = new_index

func goto_prev_turn():
	if index == 0:
		return
	
	turn_finished.emit(index)
	var current_active = active_character
	var new_index: int = (active_character.get_index() - 1) % get_child_count()
	index = new_index
	active_character = get_child(new_index)
	play_turn()
