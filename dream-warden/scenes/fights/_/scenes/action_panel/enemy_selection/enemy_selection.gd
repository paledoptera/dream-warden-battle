class_name EnemySelection extends Node2D


@export var options_parent: Node


func refresh() -> void:
	var enemy: Enemy = Battle.enemies[0]
	$Options/Enemy.text = enemy.title
	$Options/Enemy/HP.max_value = enemy.hp_max
	$Options/Enemy/HP.value = enemy.hp
	var percentage = int(enemy.hp*100.0) / int(enemy.hp_max)
	$Options/Enemy/HP/Number.text = str(percentage,"%")


func _on_selected_changed(current: int, previous: int):
	Battle.target = current
	
func _on_accepted() -> void:
	Battle.goto_next_phase()
