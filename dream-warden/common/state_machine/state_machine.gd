class_name StateMachine extends Node

signal state_entered(state:State, string_action: StringName)
signal state_exited(state:State, string_action: StringName)
signal action(string: StringName)
signal event(string: StringName)

var current_state: State

func _ready() -> void:
	
	for i in get_children():
		if i is not State:
			continue
		
		i.index = i.get_index()
		i.change_state.connect(change_state)
		i.event.connect(echo_event)
	
	change_state(get_child(0))

func change_state(state: State, new_action: StringName = "init"):
	if current_state:
		state_exited.emit(current_state,new_action)
		action.disconnect(current_state.action)
		if current_state.events:
			current_state.perform_events(current_state.events.exit)
		current_state.state_exited.emit()
		
	current_state = state
	state_entered.emit(current_state,new_action)
	current_state.state_entered.emit()
	action.connect(current_state.action)
	if current_state.events:
		current_state.perform_events(current_state.events.enter)
	

func echo_event(string: StringName):
	#print("Event echoed: ", string)
	event.emit(string)
