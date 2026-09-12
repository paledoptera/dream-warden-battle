extends Node

const DEFAULT_SOUL_SPEED: float = 120.0
const DEFAULT_DEFEND_TP: int = 16
const DEFAULT_ATTACK_TP: int = 6

class BattleFlags:
	signal soul_speed_changed(value: float)
	
	var soul_speed: float = DEFAULT_SOUL_SPEED:
		set(value):
			soul_speed = value
			soul_speed_changed.emit(value)
	var soul_bearer: StringName = "susie" # this is for animations
	var mercy_disabled: bool = false
	var defend_tp: int = DEFAULT_DEFEND_TP
	var attack_tp: int = DEFAULT_ATTACK_TP




var battle = BattleFlags.new()
var hard_mode: bool = false
var in_battle: bool = false


func get_flag(flag: StringName, flag_class: StringName = "") -> Variant:
	var parent = _find_flag_class(flag_class)
	
	if flag not in parent:
		return null
	
	return parent.get(flag)


func set_flag(flag: StringName, value: Variant, flag_class: StringName = "") -> bool:
	var parent = _find_flag_class(flag_class)
	
	if flag not in parent:
		return false
	
	parent.set(flag,value)
	return true


func _find_flag_class(flag_class_name: StringName = "") -> Object:
	var flag_class = self
	
	if flag_class_name != "":
		if flag_class_name in self:
			flag_class = get(flag_class_name)
			
	return flag_class
