@abstract class_name FlagConditional extends Node

@export var flag: StringName
@export var value: Variant
@export var one_shot: bool = false


func _ready() -> void:
	if Flags.get_flag(flag) == null:
		queue_free()
	
	await get_tree().physics_frame
	
	check_flag()

func _process(delta: float) -> void:
	if one_shot:
		queue_free()
		return
	
	check_flag()


func check_flag():
	if Flags.get_flag(flag) == value:
		flag_equals_value()
	else:
		flag_not_value()

@abstract func flag_not_value() -> void

@abstract func flag_equals_value() -> void
