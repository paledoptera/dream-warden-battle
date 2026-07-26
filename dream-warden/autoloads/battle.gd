extends Node

var heroes: Array
var enemies: Array

var soul

var tp: float = 0.0:
	set(value):
		tp = value
		tp = clampf(tp,0.0,100.0)
		tp_changed.emit(tp)

signal reset
signal heroes_updated(parent_node: Node)
signal enemies_updated(parent_node: Node)
signal tp_changed(tp: float)

func _ready() -> void:
	heroes_updated.connect(update_heroes)
	enemies_updated.connect(update_enemies)


func update_heroes(parent_node: Node):
	heroes.clear()
	heroes = parent_node.get_children()

func update_enemies(parent_node: Node):
	enemies.clear()
	enemies = parent_node.get_children()
	

func get_opening_line() -> DialogueString:
	
	var dialogue = enemies[0].get_opening_line()
	
	return dialogue
	
	## below is unused for now (will be used if there's multiple enemies)
	
	#for enemy: Enemy in enemies:
		#if enemy == enemies[0]
			#continue
		#
		#if dialogue.text != "":
			#dialogue.text += monster.get_opening_line().text
	#
	#if dialogue.text == "":
		#if Global.monsters.size() == 1:
			#dialogue.text = "  * You encountered a monster!"
		#else:
			#dialogue.text = "  * You encountered some monsters!"
	#
	#return dialogue
