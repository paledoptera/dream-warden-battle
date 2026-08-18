class_name ItemSelection extends Node2D

@export var options_parent: Node
var items: Array[Item]
var hero: Hero

func refresh() -> void:
	hero = Battle.heroes[0]
	items = PlayerInventory.items
	
	_on_selected_changed(0,-1)

	for i in range(options_parent.get_child_count()):
		var option = options_parent.get_child(i)
		
		if i >= items.size() or not items[i]:
			option.remove_from_group("menu_option")
			option.visible = false
			continue
		
		option.add_to_group("menu_option")
		option.text = items[i].title
	
	Menu.hook_cursor($Options,Menu.Layout.TWO_BY_TWOCOLUMN,0)

func _on_selected_changed(current: int, previous: int):
	$Sprite2D.global_position = options_parent.get_child(current).global_position+Vector2(16.0,33.0)
	var item = items[current]
	
	$Description.text = item.description
	

func _on_accepted() -> void:
	var item = items[Menu.selected]
	Battle.goto_next_phase()
	PlayerInventory.use_item(Menu.selected,hero,hero)
