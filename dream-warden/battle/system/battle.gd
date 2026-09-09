class_name Battle extends CanvasLayer

signal turn_state_changed
signal turn_number_changed(val: int)
signal action_reversed

const SCENE = preload("uid://cxu6vtdp70cut")

enum TurnState {PLAYER, ACTION, ENEMY}

var turn_state: TurnState:
	set(value):
		turn_state = value
		turn_state_changed.emit(value)

var turn: int = -1: 
	set(value):
		turn = value
		turn_number_changed.emit(value)
var action_menu: ActionMenu
var waiting_on_minigame: bool = false
var minigame: Node
var attack_scenes: Array[Node]

static func start(enemies: Array[CharacterStats], stage: PackedScene, party: Array[CharacterStats] = Party.active_party, soul_bearer: StringName = "") -> Node:
	var scene = SceneLoader.change_scene(SCENE)
	
	Party.enemy.clear()
	Party.enemy = enemies
	
	if party != Party.hero:
		Party.hero.clear()
		Party.hero = party
	
	if soul_bearer == "":
		Party.soul_bearer = Party.hero[0].character_id
	else:
		Party.soul_bearer = soul_bearer
	
	var stage_inst = stage.instantiate()
	scene.add_child(stage_inst)
	
	return scene

func _ready() -> void:
	
	turn_state_changed.connect(_on_turn_state_changed)
	
	turn_state = TurnState.PLAYER

	$TurnQueue.turn_finished.connect(check_turn)
	$TurnQueue.reverse_action.connect(reverse_action)
	%CharacterStatusManager.reposition_action_menu.connect(_reposition_action_menu)
	
	EventBus.battle_event.connect(battle_event)
	EventBus.enter_fight_minigame.connect(fight_minigame_start)
	EventBus.hero_attack.connect(hero_attack)
	
	Party.tp_changed.connect(%TPBar._update_tp)

func check_turn(index: int) -> void:
	await get_tree().physics_frame
	$TurnQueue.play_turn()

func reverse_action(index: int) -> void:
	var character = $TurnQueue.get_child(index)
	
	var action: BattleEvent
	for i in %EventQueue.queue:
		if i.character == index:
			action = i
			break
	
	if not action:
		return
	
	%EventQueue.add_event(action,true)
	
	action_reversed.emit()
	
func _on_turn_state_changed(value: TurnState):
	match value:
		TurnState.PLAYER:
			await get_tree().process_frame
			turn += 1
			start_flavor_text()
			open_action_menu()
			refresh_queue()
			await $TurnQueue.all_turns_finished
			close_action_menu()
			turn_state = TurnState.ACTION
		
		TurnState.ACTION:
			Dialogue.clear_text.emit()
			%EventQueue.execute_events()
			await %EventQueue.events_finished
			await get_tree().process_frame
			if waiting_on_minigame:
				await EventBus.end_fight_minigame
			
			turn_state = TurnState.ENEMY
		
		TurnState.ENEMY:
			print("enemy phase")
			
			# check if dead
				# end battle
			
			var dialogue = %BattleDataManager.get_dialogue()
			if dialogue:
				Dialogue.display_text(dialogue)
				await Dialogue.text_finished
				Dialogue.clear_text.emit()

			# do dialogue / cutscenes
			enemy_attack(self) # do attack

func _reposition_action_menu(index: int) -> void:
	action_menu.stats_tab = %CharacterStatusManager.get_child(index)


func _on_action_selected(action_type: int, option: int, target: int) -> void:
	var event: BattleEvent = get_action_data(action_type, option, target)
	$TurnQueue.active_character.action = event
	event.character = $TurnQueue.active_character.get_index()
	%EventQueue.add_event(event, false)

	$TurnQueue.active_character.turn_finished.emit()
	pass # Replace with function body.

func _on_action_cancel_turn() -> void:
	$TurnQueue.goto_prev_turn()
	
	pass

func open_action_menu() -> void:
	action_menu = ActionMenu.spawn()
	add_child(action_menu)
	_reposition_action_menu(0)
	action_menu.action_cancelled.connect(_on_action_cancel_turn)
	action_menu.action_selected.connect(_on_action_selected)
	action_menu.menu_opened.connect(_on_action_text_menu_opened)
	action_menu.menu_closed.connect(_on_action_text_menu_closed)

func close_action_menu() -> void:
	action_menu.queue_free()
	action_menu = null


func get_action_data(action_type: int, option: int, target: int) -> BattleEvent:
	var event = BattleEvent.new()
	
	print("ACTION TYPE: ", action_type, " option: ", option, " target: ", target)
	event.action_type = action_type as BattleEvent.Type
	event.option = option
	event.target = target
	print(" EVENT", event.action_type)
	
	match event.action_type:
		BattleEvent.Type.DEFEND:
			event.data["tp"] = 20.0
			event.priority = 2
			
		BattleEvent.Type.FIGHT:
			event.priority = 0
			
		BattleEvent.Type.MAGIC:
			event.priority = 1
			
		BattleEvent.Type.ITEM:
			event.priority = 1
			
		BattleEvent.Type.MERCY:
			event.priority = 1
	
	return event

func refresh_queue() -> void:
	var heroes = Party.hero
	
	for ind in range(3):
		if ind >= heroes.size():
			%CharacterStatusManager.get_child(ind).hide()
			%TurnQueue.get_child(ind).exists = false
			continue
		
		var hero = heroes[ind]
		var fighter: Fighter = %TurnQueue.get_child(ind)
		
		if hero.hp < 0:
			fighter.downed = true
		else:
			fighter.downed = false
		
		fighter.name = hero.name
		
		%CharacterStatusManager.get_child(ind).show()
	
	$TurnQueue.build_queue()

func _on_action_text_menu_closed() -> void:
	%DialogueBox.show()

func _on_action_text_menu_opened() -> void:
	%DialogueBox.hide()

func battle_event(event: StringName, value: Variant) -> void:
	match event:
		"action_canceled":
			pass
		
		"tp_add":
			Party.tp += value
		
		"tp_sub":
			Party.tp -= value

		#"spell_prepare":
			#var current_spell = value
			#var spell_event = setup_party_event(preload("uid://bse4pngnbunal")) # be_action_spell.tres
			#spell_event.data["tp"] = current_spell.tp_cost
			#spell_event.data["spell"] = current_spell
			#current_spell_events[get_current_party_member()] = spell_event
			#
			#if not current_spell.targets_own_party:
				#%ActionState.action.emit("choose_enemy")
				#$ActionState/ChooseEnemy.transitions["cancel"] = $ActionState/ChooseSpell
		#
		#"item_prepare":
			#var current_item = value.duplicate()
			#print(current_item)
			#current_item_events.resize(3)
			#var item_event = setup_party_event(preload("uid://ch11xx7yyafvo")) #be_action_item.tres
			#item_event.data["item"] = current_item
			#item_event.data["index"] = PlayerInventory.items.find(value)
			#item_event.data["ref"] = value
			#current_item_events[get_current_party_member()] = item_event
			#
			#if current_item.targets_enemy:
				#%ActionState.action.emit("choose_enemy")
				#$ActionState/ChooseEnemy.transitions["cancel"] = $ActionState/ChooseItem
			#else:
				#%ActionState.action.emit("choose_hero")
				#$ActionState/ChooseHero.transitions["cancel"] = $ActionState/ChooseItem
			

func fight_minigame_start(characters: Array, targets: Array):
	waiting_on_minigame = true
	var fight_minigame = _start_minigame(preload("uid://he0wouxpjxmq"), %MenuParent) # fight_minigame.tscn
	fight_minigame.targets = targets
	fight_minigame.enable(characters)
	await EventBus.end_fight_minigame
	waiting_on_minigame = false

func _start_minigame(new_minigame: PackedScene, parent: Node = null) -> Node:
	
	var inst = new_minigame.instantiate()
	if not parent:
		add_child(inst)
	else:
		parent.add_child(inst)
	minigame = inst
	return minigame

func hero_attack(event: AttackEvent):
	print("HERO ATTACKS! ")
	var final_damage = event.get_damage()
	print(event, event.target, event.damage)
	var damage_number = FloatingText.initialize_text(str(final_damage),Color.WHITE)
	EventBus.actor_trigger_damage_number.emit(event.target.character_id,damage_number)


func enemy_attack(parent_node: Node) -> void:
	var attack = %BattleDataManager.get_attack()
	
	if not attack.scene:
		return
	
	
	if attack_scenes:
		for i in attack_scenes:
			if i:
				i.queue_free()
		attack_scenes.clear()

	var main_attack_scene = attack.scene.instantiate()
	attack_scenes.append(main_attack_scene)
	
	await animate_soul_transition(main_attack_scene,false)
	add_child(main_attack_scene)
	main_attack_scene.global_position = $Helpers/AttackPos.global_position
	
	if attack.length:
		await get_tree().create_timer(attack.length).timeout
	else:
		await EventBus.attack_area_end
	
	await animate_soul_transition(main_attack_scene,true)
	
	turn_state = TurnState.PLAYER
	

func animate_soul_transition(attack_scene: Node, end: bool):
	var transition = SoulTransition.create(attack_scene)
	add_child(transition)
	transition.global_position = $Helpers/AttackPos.global_position
	transition.animate_soul_transition(end)
	await transition.done

func start_flavor_text() -> void:
	%DialogueBox.show()
	
	var dialogue_line: DialogueString
	
	if turn == 0:
		dialogue_line = %BattleDataManager.get_opening_line()
	else:
		dialogue_line = %BattleDataManager.get_flavor_text()
	
	if not dialogue_line:
		dialogue_line = DialogueString.new("* It is known.")
	
	Dialogue.display_text(dialogue_line)
