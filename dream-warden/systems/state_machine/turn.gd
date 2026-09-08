class_name Turn extends Node

signal goto_next_turn
signal goto_prev_turn
signal event(string: StringName)

@export var events : TurnEvents
var index: int

func _ready() -> void:
	if not events:
		events = TurnEvents.new()

func start():
	print("Turn started ", self)
	_perform_events(events.start)
	
	
func end():
	_perform_events(events.end)

func cancel():
	_perform_events(events.cancel)

func _perform_events(array: Array[StringName]):
	if not array:
		return
	
	for i in array:
		event.emit(i)
