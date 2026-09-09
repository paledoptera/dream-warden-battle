class_name BattleEvent extends Resource

enum Type {FIGHT, MAGIC, ITEM, MERCY, DEFEND}

var character: int = 0
var action_type := Type.FIGHT
var option: int = -1
var target: int = 0
var priority: int = 0
var data: Dictionary = {}
