class_name State extends Node

signal state_entered
signal state_exited
signal change_state(state: State, string_action: StringName)
signal event(string: StringName)


var index: int
@export var transitions: Dictionary[StringName, State]
@export var events: StateEvents

func action(string: StringName):
	if string not in transitions:
		return
	
	var new_state = transitions[string]
	change_state.emit(new_state, string)

func perform_events(array: Array[StringName]):
	if not array:
		return
	
	for i in array:
		event.emit(i)
