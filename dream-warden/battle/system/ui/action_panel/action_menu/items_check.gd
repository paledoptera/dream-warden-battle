extends Node

func _process(delta: float) -> void:
	if not PlayerInventory.items:
		get_parent().disabled = true
		
