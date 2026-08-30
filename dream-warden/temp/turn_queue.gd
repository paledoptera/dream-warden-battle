class_name TurnQueue extends Node

signal turn_changed(turn: Turn)
signal event(string: StringName)

@onready var current_turn: Turn:
	set(value):
		current_turn = value
		turn_changed.emit(current_turn)
@export var minimum_cancel: int = -1
@export var maximum_cancel: int = -1

func _ready() -> void:
	for i in get_children():
		if i is not Turn:
			continue
		i.index = i.get_index()
		i.goto_next_turn.connect(goto_next_turn)
		i.goto_prev_turn.connect(goto_prev_turn)
		i.event.connect(echo_event)
	
	await get_tree().physics_frame
	current_turn = get_child(0)
	current_turn.start()
	


func goto_next_turn():
	current_turn.end()
	move_child(current_turn,-1)
	current_turn = get_child(0)
	current_turn.start()

func goto_prev_turn():
	if maximum_cancel != -1:
		if current_turn.index >= maximum_cancel:
			return
	if minimum_cancel != -1:
		if current_turn.index < minimum_cancel:
			return

	current_turn.cancel()
	current_turn = get_child(-1)
	move_child(current_turn,0)
	current_turn.start()

func echo_event(string: StringName):
	#print("Event echoed: ", string)
	event.emit(string)
