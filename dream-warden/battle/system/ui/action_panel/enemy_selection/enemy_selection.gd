class_name EnemySelection extends Control

signal target_chosen(target: int)

@export var options_parent: Node

var enemies: Array[CharacterStats]
var selected: int = 0


func refresh() -> void:
	enemies = Party.enemy.duplicate(true)
	
	for i in range($Options.get_child_count()):
		var option = $Options.get_child(i)
		
		
		if i >= enemies.size() or not enemies[i]:
			option.remove_from_group("menu_option")
			option.visible = false
			continue
		
		option.refresh(i)
		
		option.add_to_group("menu_option")
		print("enemy = REFRESHED")

func _on_enemy_selected(index: int) -> void:
	print("TARGET INDEX: ", index)
	target_chosen.emit(index)
