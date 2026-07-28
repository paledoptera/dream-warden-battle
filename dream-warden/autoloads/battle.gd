extends Node

enum State {CHOOSE_ACTION, CHOOSE_ENEMY, CHOOSE_SPELL, CHOOSE_ITEM, HERO_DIALOGUE, ENEMY_DIALOGUE, ATTACK_START, ATTACK_END}

var state := State.CHOOSE_ACTION:
	set(value):
		state_changed.emit(value,state)
		state = value

var heroes: Array
var enemies: Array

var turn: int = 0

var soul: Soul

var enemy_attacking: bool = false:
	set(value):
		var last = enemy_attacking
		enemy_attacking = value
		if last != enemy_attacking:
			if value:
				state = State.ATTACK_START
				attack_start.emit()
			else:
				state = State.ATTACK_END
				attack_end.emit()
				await get_tree().create_timer(0.1).timeout
				turn += 1
				state = State.CHOOSE_ACTION
				

var tp: float = 0.0:
	set(value):
		tp = value
		tp = clampf(tp,0.0,100.0)
		tp_changed.emit(tp)

signal reset
signal heroes_updated(parent_node: Node)
signal enemies_updated(parent_node: Node)
signal tp_changed(tp: float)
signal attack_start
signal attack_end
signal state_changed(new_state: State, last_state: State)

func _ready() -> void:
	heroes_updated.connect(update_heroes)
	enemies_updated.connect(update_enemies)


func update_heroes(parent_node: Node):
	heroes.clear()
	heroes = parent_node.get_children()

func update_enemies(parent_node: Node):
	enemies.clear()
	enemies = parent_node.get_children()

func do_attack(parent_node: Node) -> void:
	var attack = enemies[0].get_attack()
	
	if attack.scene:
		var attack_scene = attack.scene.instantiate()
		parent_node.add_child(attack_scene)
	
		await get_tree().create_timer(attack.length).timeout
		attack_scene.queue_free()
	
	enemy_attacking = false
	return
	

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

func get_flavor_text() -> DialogueString:
	var dialogue = enemies[0].get_flavor_text()
	return dialogue
