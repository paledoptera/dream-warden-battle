extends Node

signal selected_changed(current: int, previous: int)
signal accepted
signal canceled

enum Layout {HORIZONTAL, VERTICAL, TWO_BY_TWOCOLUMN}

@export var cursor: Sprite2D

var options: Array[Node]
var disabled_options: Array[int]
var current_menu: Node
var previous_menu: Node
var selected: int = 0
var current_layout:= Layout.VERTICAL

## Misc
var current_selected_property : StringName = "selected"

## Decor
var cursor_texture: Texture2D
var snd_move: AudioStream
var snd_select: AudioStream



func _ready() -> void:
	selected_changed.connect(_on_selected_changed)
	canceled.connect(_on_canceled)
	
func set_cursor_sprite(texture: Texture2D):
	cursor_texture = texture
	
	if not cursor:
		return
	
	cursor.texture = texture

func set_sounds(move: AudioStream, select: AudioStream):
	snd_move = move
	snd_select = select


func _unhandled_input(event: InputEvent) -> void:
	if not cursor:
		return
	
	change_selection(event)
	
	if event.is_action_pressed("confirm"):
		accepted.emit()
		do_selected_action()
		Sound.play(snd_select)
	
	if event.is_action_pressed("cancel"):
		canceled.emit()

	
	get_viewport().set_input_as_handled()

func change_selection(event: InputEvent):
	var last_selected = selected
	
	var prev: String
	var next: String
	var standard: bool = true
	
	match current_layout:
		Layout.HORIZONTAL:
			prev = "left"
			next = "right"
		Layout.VERTICAL:
			prev = "up"
			next = "down"
		Layout.TWO_BY_TWOCOLUMN:
			standard = false
			var half = 2.0
			#var half = ceilf(float(options.size()))/2
			
			if event.is_action_pressed("up"):
				selected -= half
				
			elif event.is_action_pressed("down"):
				selected += half
			
			
			if event.is_action_pressed("right"):
				selected += 1
				if selected == half:
					selected -= half
				if selected == options.size():
					selected = half
				
			
			if event.is_action_pressed("left"):
				selected -= 1
				if selected == -1:
					selected = half-1
				elif selected == half-1:
					selected = options.size()-1
				
			
	
	if standard:
		if event.is_action_pressed(prev):
			selected -= 1
		elif event.is_action_pressed(next):
			selected += 1
	
	if disabled_options:
		if selected in disabled_options:
			var sign: int
			if last_selected < selected:
				sign = 1
			else:
				sign = -1
				
			while selected in disabled_options:
				selected += sign
				selected = wrapi(selected,0,options.size())
	
	selected = wrapi(selected,0,options.size())
	
	if last_selected != selected:
		selected_changed.emit(selected,last_selected)
		Sound.play(snd_move)

func do_selected_action():
	pass


func open(menu_scene: Node, cursor_visible := true) -> void:
	if current_menu:
		close()
	
	current_menu = menu_scene

	
	cursor = Sprite2D.new()
	if cursor_texture:
		cursor.texture = cursor_texture
	cursor.visible = cursor_visible
	
	current_menu.add_child(cursor)
	
	if current_menu.has_method("_on_selected_changed"):
		selected_changed.connect(current_menu._on_selected_changed)
	
	if current_menu.has_method("_on_accepted"):
		accepted.connect(current_menu._on_accepted)
	


func hook_cursor(options_parent: Node, layout := Layout.VERTICAL, default_option: int = 0):
	options.clear()
	disabled_options.clear()
	
	current_layout = layout
	selected = -999
	selected = default_option
	
	
	for i in options_parent.get_children():
		if i.is_in_group("menu_option"):
			options.append(i)
	
	_fix_cursor_position()

func close() -> void:
	if cursor:
		cursor.queue_free()
		cursor = null
	
	if current_menu:
		if current_menu.has_method("_on_accepted"):
			accepted.disconnect(current_menu._on_accepted)
		if current_menu.has_method("_on_selected_changed"):
			selected_changed.disconnect(current_menu._on_selected_changed)
		current_menu = null
	
	options.clear()

func _on_selected_changed(current: int, previous: int):
	if current_selected_property in current_menu:
		current_menu.set(current_selected_property,current)

	_fix_cursor_position()

func _on_canceled() -> void:
	if Flags.in_battle:
		EventBus.battle_goto_prev_phase.emit()

func _fix_cursor_position() -> void:
	if not options or not cursor:
		return
	
	if "global_position" in options[selected]:
		cursor.global_position = options[selected].global_position
