class_name HeroSelection extends Control

signal target_chosen(target: int)

@export var options_parent: Node
var selected: int = 0


func _ready() -> void:
	var heroes = Party.hero.duplicate_deep()
	
	for i in range($Options.get_child_count()):
		var option = $Options.get_child(i)
		
		if i >= heroes.size() or not heroes[i]:
			option.remove_from_group("menu_option")
			option.visible = false
			continue
		
		option.add_to_group("menu_option")
		option.text = heroes[i].name
		option.get_node("HP").value = heroes[i].hp
		option.get_node("HP").max_value = heroes[i].hp_max
