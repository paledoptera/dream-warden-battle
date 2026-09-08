class_name ItemSelection extends Control

var items: Array[Item]
var hero: Hero
#

func _ready() -> void:
	items = PlayerInventory.items
	_on_selected_changed(0,-1)
	for i in range($Options.get_child_count()):
		var option = $Options.get_child(i)
		
		if i >= items.size() or not items[i]:
			option.remove_from_group("menu_option")
			option.visible = false
			continue
		
		option.add_to_group("menu_option")
		option.text = items[i].title

func _on_selected_changed(current: int, previous: int):
	$Sprite2D.global_position = $Options.get_child(current).global_position+Vector2(16.0,33.0)
	var item = items[current]
	
	$Description.text = item.description
	

func _on_accepted() -> void:
	var item = items[Menu.selected]
	EventBus.battle_event.emit("item_prepare",item)
	#PlayerInventory.use_item(Menu.selected,hero,hero)
