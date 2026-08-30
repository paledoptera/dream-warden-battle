class_name EnemySelection extends Node2D

signal target_chosen(target: int)

@export var options_parent: Node
var selected: int = 0
#
func _ready() -> void:
	var enemy := Party.enemy[0]
	$Options/Enemy.text = enemy.name
	$Options/Enemy/HP.max_value = enemy.hp_max
	$Options/Enemy/HP.value = enemy.hp
	var percentage = int(enemy.hp*100.0) / int(enemy.hp_max)
	$Options/Enemy/HP/Number.text = str(percentage,"%")

func _on_accepted() -> void:
	EventBus.battle_event.emit("hero_action_chosen",selected)
	queue_free()

func _on_canceled() -> void:
	queue_free()
#
#func _on_selected_changed(current: int, previous: int):
	#selected = current
#
#
#func _on_accepted() -> void:
	#target_chosen.emit()
	#BattleData.target = selected
	#EventBus.battle_goto_next_phase.emit()
