class_name HeroSelection extends Control

signal target_chosen(target: int)

@export var options_parent: Node

var selected: int = 0

func _ready() -> void:
	refresh()

func refresh() -> void:
	var heroes = Party.hero.duplicate_deep()
	
	for i in range($Options.get_child_count()):
		var option = $Options.get_child(i)
		
		if i >= heroes.size() or not heroes[i]:
			option.remove_from_group("menu_option")
			option.visible = false
			continue
		
		option.add_to_group("menu_option")
		option.get_node("Label").text = heroes[i].name
		option.get_node("HP").value = heroes[i].hp
		option.get_node("HP").max_value = heroes[i].hp_max
		print("HP = ", heroes[i].hp, " / ", heroes[i].hp_max)


func _on_enemy_selected(index: int) -> void:
	print("TARGET INDEX: ", index)
	target_chosen.emit(index)
