class_name EnemySelection extends Node2D


@export var options_parent: Node

func _on_selected_changed(current: int, previous: int):
	Battle.target = current
	
func _on_accepted() -> void:
	Battle.goto_next_phase()
