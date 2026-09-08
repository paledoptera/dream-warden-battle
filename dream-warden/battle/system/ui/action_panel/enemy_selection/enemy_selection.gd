class_name EnemySelection extends Control

signal target_chosen(target: int)

@export var options_parent: Node
var selected: int = 0
#

func _ready() -> void:
	var enemies = Party.enemy.duplicate_deep()
	
	for i in range($Options.get_child_count()):
		var option = $Options.get_child(i)
		
		if i >= enemies.size() or not enemies[i]:
			option.remove_from_group("menu_option")
			option.visible = false
			continue
		
		option.add_to_group("menu_option")
		option.text = enemies[i].name
		option.get_node("HP").value = enemies[i].hp
		option.get_node("HP").max_value = enemies[i].hp_max


func _on_enemy_selected(index: int) -> void:
	target_chosen.emit(index)
