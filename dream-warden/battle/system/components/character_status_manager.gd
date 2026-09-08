class_name CharacterStatusManager extends HBoxContainer

signal reposition_action_menu(index: int)

func _on_turn_queue_turn_started(index: int) -> void:
	print(index)
	reposition_action_menu.emit(index)
	get_child(index).open()


func _on_turn_queue_turn_finished(index: int) -> void:
	get_child(index).close()
