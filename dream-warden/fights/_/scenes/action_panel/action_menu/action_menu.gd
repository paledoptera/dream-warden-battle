extends Control

var active = true
var actions: Array
var selected: int = 0:
	set(value):
		value = wrapi(value,0,5)
		actions[selected].selected = false
		actions[value].selected = true
		selected = value
		

func _ready() -> void:
	actions = $Actions.get_children()
	actions[0].selected = true

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action("left") and not event.is_action("right"):
		return
	
	var last_selected = selected
	
	if event.is_action_pressed("left"):
		selected -= 1
	elif event.is_action_pressed("right"):
		selected += 1
	
	
	
	if last_selected != selected:
		Sound.play(preload("uid://con5cuooujhtc"))
