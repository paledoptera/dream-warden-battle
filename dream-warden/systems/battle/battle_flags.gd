class_name BattleFlags extends RefCounted

var soul_speed: float = 120.0

func get_flag(flag: StringName) -> Variant:
	if flag not in self:
		return null
	
	return get(flag)

func set_flag(flag: StringName, value: Variant) -> bool:
	if flag not in self:
		return false
	
	set(flag,value)
	return true
