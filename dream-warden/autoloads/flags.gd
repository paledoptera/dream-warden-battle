extends Node

var hard_mode: bool = false
var in_battle: bool = false
var mercy_disabled: bool = false


func get_flag(flag: StringName) -> Variant:
	if flag not in self:
		return null
	
	return get(flag)

func set_flag(flag: StringName, value: Variant) -> bool:
	if flag not in self:
		return false
	
	set(flag,value)
	return true
