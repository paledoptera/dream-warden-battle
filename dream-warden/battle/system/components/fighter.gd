class_name Fighter extends Node

signal turn_finished

@export var id: StringName = "character"
@export var max_health: int = 15
@export var attack: int = 4
@export var defense: int = 1
@export var downed: bool = false
var exists: bool = true
var action: BattleEvent
var status: int = 0

func play_turn() -> void:
	print("TURN PLAYED")

func can_take_turn() -> bool:
	if exists and not downed:
		return true
	return false
