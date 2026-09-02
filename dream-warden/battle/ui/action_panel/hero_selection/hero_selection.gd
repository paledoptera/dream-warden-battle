class_name HeroSelection extends Node2D

signal target_chosen(target: int)

@export var options_parent: Node
var selected: int = 0


func _ready() -> void:
	var heroes = Party.hero.duplicate_deep()
	
	_on_selected_changed(0,-1)
	for i in range($Options.get_child_count()):
		var option = $Options.get_child(i)
		
		if i >= heroes.size() or not heroes[i]:
			option.remove_from_group("menu_option")
			option.visible = false
			continue
		
		option.add_to_group("menu_option")
		option.text = heroes[i].name
		option.get_node("HP").value = heroes[i].hp
		option.get_node("HP").max_value = heroes[i].hp_max
##
#func _ready() -> void:
	#for i in $Options.get_childreN()
	#var enemy := Party.enemy[0]
	#$Options/Enemy.text = enemy.name
	#$Options/Enemy/HP.max_value = enemy.hp_max
	#$Options/Enemy/HP.value = enemy.hp
	#var percentage = int(enemy.hp*100.0) / int(enemy.hp_max)
	#$Options/Enemy/HP/Number.text = str(percentage,"%")


func _on_canceled() -> void:
	queue_free()
#
func _on_selected_changed(current: int, previous: int):
	$Sprite2D.global_position = $Options.get_child(current).global_position+Vector2(64.0,33.0)
	EventBus.battle_event.emit("target_changed", selected)

func _on_accepted() -> void:

	EventBus.battle_event.emit("hero_action_chosen",selected)
	queue_free()
