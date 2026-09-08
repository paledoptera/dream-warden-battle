class_name BattleDataManager extends Node

var turn = 0
var repetitions = 0
var enemies: Array[CharacterStats]


func update() -> void:
	enemies = Party.enemy.duplicate()


func get_opening_line() -> DialogueString:
	update()
	
	var enemies = Party.enemy
	var enemy: CharacterStatsEnemy
	var string: DialogueString
	
	
	enemy = enemies[0]
	string = enemy.opening_line_singular
	
	
	if enemies.size() >= 2:
		for i in enemies:
			if i == enemy:
				continue
			string.text += enemy.opening_line_plural.text
	
	if not string or string.text == "":
		if enemies.size() > 1:
			string = DialogueString.new("* The enemies approach!")
		else:
			string = DialogueString.new("* The enemy approaches!")
	
	return string


func get_attack() -> AttackData:
	update()
	
	var attack_list: AttackList
	var attacks: Array
	
	attack_list = enemies[0].attack_list
	attacks = attack_list.attacks
	
	var attack_turn = wrapi(turn,0,attacks.size())
	
	if attack_turn < turn:
		repetitions = floor(float(turn) / float(attacks.size()))
		print("REPITITIONS: ", repetitions)
	
	match attack_list.attack_order:
		attack_list.Order.SEQUENTIAL:
			pass
			
		attack_list.Order.RANDOM:
			attacks.shuffle()
	

	if attacks[attack_turn]:
		return attacks[attack_turn]
	else:
		return AttackData.new()

func get_dialogue() -> DialogueBlock:
	return null


#
#func get_attack() -> PackedScene:

	#
	#if attack_list.attack_order == attack_list.Order.RANDOM:
		#attack = attack_list.attacks.pick_random()
	#elif attack_list.attack_order == attack_list.Order.SEQUENTIAL:
		#attack = attack_list
	#
	#
	#return attack
	#


func _on_battle_turn_number_changed(val: int) -> void:
	turn = val
