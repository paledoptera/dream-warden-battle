class_name ItemSelection extends Control

signal option_chosen(option: int)

var items: Array[Item]
var index: int = 0
#var hero: Hero
#

func _ready() -> void:
	refresh()
	_on_selected_changed(0)


func refresh():
	items = PlayerInventory.items
	
	if not items:
		return
	
	for i in range($ItemContainer/Options.get_child_count()):
		var option = $ItemContainer/Options.get_child(i)
		
		if i >= items.size() or not items[i]:
			option.remove_from_group("menu_option")
			option.visible = false
			continue
		
		
		option.visible = true
		option.add_to_group("menu_option")
		option.get_node("Label").text = items[i].name
	
	if items.size() <= 6:
		$Arrow.visible = false
	else:
		$Arrow.visible = true

func _on_selected_changed(current: int):
	if not items:
		return
	
	var item = items[current]
	
	index = current
	
	$Description.text = item.description


func _on_selected(ind: int) -> void:
	option_chosen.emit(ind)

func _input(event: InputEvent) -> void:
	if items.size() <= 6:
		return
	
	if event.is_action_pressed("down"):
		if index == 4 or index == 5:
			$ItemContainer/Options.position.y = -114.0
			$Arrow.base_pos = 16.0
			$Arrow.flip_v = true
	elif event.is_action_pressed("up"):
		if index == 6 or index == 7:
			$ItemContainer/Options.position.y = -18.0
			$Arrow.base_pos = 86.0
			$Arrow.flip_v = false
