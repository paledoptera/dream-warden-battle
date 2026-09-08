class_name MenuInputManager extends Node

signal menu_opened
signal menu_closed

@export var menus: Dictionary[Node,MenuConfigResource]
var menu_stack: Array[Control] = []


func _ready() -> void:
	for menu in menus.keys():
		var options = Tools.find_children_in_group(menu,"menu_option", true)
		
		for option in options:
			if option is RPGMenuButton:
				option.menu_sounds = menus[menu].menu_sounds
				option.menu = menus[menu]
				

func open_menu(menu: Control) -> void:
	if menu_stack.size() > 0:
		var last_menu = menu_stack.back()
		_change_menu_state(last_menu,false)
	
	if menu not in menu_stack:
		menu_stack.append(menu)
	
	_change_menu_state(menu,true)
	
	if menus[menu].selected_option != menus[menu].default_option:
		_focus_indexed_option(menu,menus[menu].selected_option)
	else:
		_focus_first_control(menu)
	
	menu_opened.emit()


func close_menu() -> void:
	if menu_stack.size() == 1:
		menu_closed.emit()
		return

	var current = menu_stack.pop_back()
	_change_menu_state(current,false)

	if menu_stack.is_empty():
		return
	
	var previous = menu_stack.back()
	open_menu(previous)

func close_all_menus():
	while menu_stack.size() > 1:
		close_menu()


func _change_menu_state(menu: Control, enabled: bool) -> void:
	if enabled:
		menu.show()
	elif not menus[menu].keep_open:
		menu.hide()
	
	var options = Tools.find_children_in_group(menu,"menu_option",true)
	for node in options:
		if node is Control:
			
			node.mouse_filter = Control.MOUSE_FILTER_IGNORE
			node.focus_mode = Control.FOCUS_NONE if not enabled else Control.FOCUS_ALL
			print(node, " is control, setting focus mode to ", node.focus_mode)


func _focus_first_control(menu: Control) -> void:
	var first := _find_first_focusable(menu)

	if first:
		first.grab_focus()

func _focus_indexed_option(menu: Control, index: int = 0) -> void:
	var options = Tools.find_children_in_group(menu, "menu_option", true)
	options[index].grab_focus()

func _find_first_focusable(node: Node) -> Control:
	for child in node.get_children():
		if child is Control and child.focus_mode != Control.FOCUS_NONE:
			return child

		var result := _find_first_focusable(child)

		if result:
			return result

	return null

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		close_menu()
