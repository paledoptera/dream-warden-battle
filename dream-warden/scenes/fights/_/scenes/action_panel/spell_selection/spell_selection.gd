class_name SpellSelection extends Node2D

@export var options_parent: Node
var test: int
var spells: Array[Spell]
var hero: Hero

func refresh() -> void:
	hero = Battle.heroes[0]
	spells = hero.spells
	
	for i in range(options_parent.get_child_count()):
		var option = options_parent.get_child(i)
		if i >= spells.size():
			option.remove_from_group("menu_option")
			option.visible = false
			continue
		
		option.add_to_group("menu_option")
		option.text = spells[i].title
		
		var spell = spells[i]
		if spells[i].tp_cost > Battle.tp:
			option.modulate = Color("7f7f7f")
		else:
			option.modulate = Color.WHITE
	
	Menu.hook_cursor($Options,Menu.Layout.TWO_BY_TWOCOLUMN,0)

func _on_selected_changed(current: int, previous: int):
	$Sprite2D.global_position = options_parent.get_child(current).global_position+Vector2(16.0,33.0)
	var spell = spells[current]
	if spell.tp_cost == 0:
		$TPCost.visible = false
	else:
		$TPCost.visible = true
		$TPCost.text = str("\n\n",spells[current].tp_cost, "% TP")
	
	$Description.text = spell.description
	

func _on_accepted() -> void:
	var spell = spells[Menu.selected]
	if spell.tp_cost > Battle.tp:
		return
	
	Battle.goto_next_phase()
	spells[Menu.selected].cast(hero, null)
	
