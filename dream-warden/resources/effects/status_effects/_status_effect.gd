
class_name StatusEffect extends Resource

@export var name: StringName
@export var turn_duration: int = 3

func on_apply(context) -> void:
	pass

func on_turn_start(context) -> void:
	pass

func on_turn_end(context) -> void:
	pass

func on_damage_taken(context) -> void:
	pass

func on_attack(context) -> void:
	pass

func on_remove(context) -> void:
	pass
