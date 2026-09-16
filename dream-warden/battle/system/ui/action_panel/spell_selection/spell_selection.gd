class_name SpellSelection extends Control

signal option_chosen(option: int)

var test: int
@export var spells: Array[Spell]
var index: int = 0
#var hero: Hero

func refresh() -> void:
	spells = Party.get_target_hero(index).spells
	
	for i in range($Options.get_child_count()):
		var option = $Options.get_child(i)
		if i >= spells.size():
			option.remove_from_group("menu_option")
			option.visible = false
			continue
		
		option.add_to_group("menu_option")
		option.get_node("Label").text = spells[i].name
		
		var spell = spells[i]
		if spells[i].tp_cost > Party.tp:
			option.modulate = Color("7f7f7f")
		else:
			option.modulate = Color.WHITE

#
func _on_selected_changed(current: int):
	$Sprite2D.global_position = $Options.get_child(current).global_position+Vector2(16.0,33.0)
	var spell = spells[current]
	
	if spell.tp_cost == 0:
		$TPCost.visible = false
	else:
		$TPCost.visible = true
		$TPCost.text = str("\n\n",spells[current].tp_cost, "% TP")

	if Party.tp < spells[current].tp_cost:
		$Options.get_child(current).disabled = true
	else:
		$Options.get_child(current).disabled = false
	
	$Description.text = spell.description

func _on_selected(ind: int) -> void:
	option_chosen.emit(ind)
