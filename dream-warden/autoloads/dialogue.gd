extends Node

signal displaying_text(dialogue: Variant)
signal refresh
signal clear_text
signal text_finished

var queue: Array[DialogueString]
var boxes: Array[DialogueBox]
var current: DialogueString
var current_boxes: Array[DialogueBox]
var active := false

func _process(delta: float) -> void:
	if not current:
		return
		
	if current.auto_skip:
		check_if_text_finished()
			

func _unhandled_input(event: InputEvent) -> void:
	if not displaying_text:
		return
	
	if event.is_action("confirm") and event.is_pressed():
		check_if_text_finished()
	
	if event.is_action("cancel") and event.is_pressed():
		skip_text()

func display_text(dialogue: Variant):
	queue.clear()
	
	if dialogue is DialogueString:
		queue.append(dialogue.duplicate(true))
	elif dialogue is Array[DialogueString]:
		queue = dialogue.duplicate(true)
	elif dialogue is String:
		var new_dialogue = DialogueString.new()
		new_dialogue.text = dialogue
		queue.append(new_dialogue.duplicate(true))
	elif dialogue is DialogueBlock:
		queue = dialogue.text.duplicate(true)
	
	displaying_text.emit(dialogue)
	_refresh()
	
	if current.flag:
		if Flags.get_flag(Dialogue.current.flag) != null:
			Flags.set_flag(Dialogue.current.flag,Dialogue.current.flag_value)
	
	active = true

func _refresh() -> void:
	current = queue.pop_front()
	refresh.emit()
	if current.talksound_oneshot:
		Sound.play(current.talksound)

func check_if_text_finished() -> void:
	var finished = true
	for i in current_boxes:
		if i.visible_ratio < 1.0 or not current.require_input:
			finished = false
			break
	if finished:
		goto_next()

func skip_text() -> void:
	if not current:
		return
	
	if not current.is_skippable:
		return
		
	for i in current_boxes:
		i.visible_ratio = 1.0

func goto_next(hide: bool = true) -> void:
	if queue.size() > 0:
		_refresh()
	else:
		text_finished.emit()
		if not hide:
			active = false
			return
