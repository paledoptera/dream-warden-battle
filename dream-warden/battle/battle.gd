class_name Battle extends Node2D

signal change_icon(menu: ActionMenu, icon: int)

const DEFAULT_SOUL_SPEED: float = 120.0

static var BATTLE_SCENE = preload("uid://cxu6vtdp70cut")


var hero_battlers: Array[HeroBattler]
var enemy_battlers: Array[EnemyBattler]
var action_menus: Array[Node]
var element: Node
var current_target: int = 0
var current_option: int = 0
var current_spell_events: Array[BattleEvent]
var current_item_events: Array[BattleEvent]

static func start(enemies: Array[CharacterStats], stage: PackedScene, party: Array[CharacterStats] = Party.active_party) -> Node:
	var scene = SceneLoader.change_scene(BATTLE_SCENE)
	
	Party.enemy.clear()
	Party.enemy = enemies
	
	if party != Party.hero:
		Party.hero.clear()
		Party.hero = party
	
	var stage_inst = stage.instantiate()
	scene.add_child(stage_inst)
	
	return scene


## Ready -> Mostly setup, attaching signals, getting nodes and resources ready
func _ready() -> void:
	Party.soul_speed = DEFAULT_SOUL_SPEED
	Party.tp = 0.0
	
	for hero in Party.hero:
		var battler = HeroBattler.new()
		battler.character_id = hero.character_id
		hero_battlers.append(battler)
		
		
	for enemy in Party.enemy:
		enemy_battlers.append(EnemyBattler.new())
	
	# Updating TP bar
	var tp_bar = get_tree().get_first_node_in_group("tp_bar")
	Party.tp_changed.connect(tp_bar._update_tp)
	
	# Getting action menus
	action_menus = get_tree().get_nodes_in_group("action_menu")
	for i in range(action_menus.size()):
		action_menus[i].index = i
		change_icon.connect(action_menus[i].change_icon)
		action_menus[i].hero_updated(Party.hero)
	
	# Signals
	EventBus.battle_event.connect(battle_event)


## Turn queue events -> Events that are emitted from %TurnQueue
# This mostly controls inner workings of the battle engine,
# like getting dialogue or choosing/changing player actions
## NOTE:
	# TurnQueue is meant to only go in one direction, like a conveyor belt
	# It's current state is defined by the first child -> get_child(0). When it goes to the next
	# State, it moves the child in index 0 (first) to index -1 (last), so
	# it's an infinite loop of pre-defined states.
func _on_turn_queue_event(event: StringName) -> void:
	match event:
		"start_flavor_text":
			Dialogue.display_text("* This is a test dialogue")
			%TurnQueue.goto_next_turn()
			
		"end_flavor_text":
			Dialogue.clear_text.emit()
		
		"start_dialogue":
			await get_tree().create_timer(1.0).timeout
			%TurnQueue.goto_next_turn()
		
		"open_action_menu":
			var party_member = get_current_party_member()
			open_action_menu(party_member)
			%ActionState.change_state($ActionState/ChooseAction)

		"reset_hero_battlers":
			reset_hero_battlers()
		
		"do_party_actions":
			do_party_actions()
		
		"attack_anim_start":
			attack_anim_start()
		
		"attack":
			attack()
		
		"attack_anim_end":
			attack_anim_end()

## Action state events -> Events emitted from %ActionState
# Basically controls what you see on screen, what menus are open at one point.
# Current state is defined by it's "state" variable.
# More traditional state machine, which state it's currently in is controlled
# by logic like a flow chart.
func _on_action_state_event(event: StringName) -> void:
	match event:
		"open_action_menu":
			var party_member = get_current_party_member()
			open_action_menu(party_member)
		
		"freeze_action_menu":
			freeze_action_menu(get_current_party_member())
		
		"unfreeze_action_menu":
			unfreeze_action_menu(get_current_party_member())


		"show_flavor_text":
			%DialogueBox.show()
		
		"hide_flavor_text":
			%DialogueBox.hide()
		
		"menu_enemy_selection":
			var action = hero_battlers[get_current_party_member()].action as HeroBattler.Action
			match action:
				HeroBattler.Action.FIGHT, HeroBattler.Action.MERCY:
					%ChooseEnemy.transitions["cancel"] = %ChooseAction
				
				HeroBattler.Action.MAGIC:
					%ChooseEnemy.transitions["cancel"] = %ChooseSpell
				
				HeroBattler.Action.ITEM:
					%ChooseEnemy.transitions["cancel"] = %ChooseItem
				
			open_menu(preload("uid://cnthh51l1n1ux")) # enemy_selection.tscn
			
		"menu_hero_selection":
			var action = hero_battlers[get_current_party_member()].action as HeroBattler.Action
			match action:
				HeroBattler.Action.MAGIC:
					%ChooseHero.transitions["cancel"] = %ChooseSpell
				
				HeroBattler.Action.ITEM:
					%ChooseHero.transitions["cancel"] = %ChooseItem
			open_menu(preload("uid://c4bcqpaoppovb")) # hero_selection.tscn
			
		"menu_spell_selection":
			open_menu(preload("uid://um2a64cmuqm6")) # spell_selection.tscn
			
		"menu_item_selection":
			open_menu(preload("uid://bfe6w1e1the6h")) # item_selection.tscn
		
		"clear_menus":
			clear_menus()
		
		"close_current_menu":
			close_current_menu()


## Battle events -> Mostly events from %EventQueue, but can be called
## by any node by using EventBus.battle_event()
# For the most part these events are asynchronous. They can be called at any time
# and don't rely on other events to "start" or "finish" tasks.
# When calling from the EventBus signal, these events will go off automatically and in no
# particular order. Otherwise, they will be called in a specific order defined by
# %EventQueue's execute_events method
# (which is called during the PartyActions turn in TurnQueue)
func battle_event(event: StringName, value: Variant) -> void:
	match event:
		"action_selected":
			var party_member = get_current_party_member()
			var hero = hero_battlers[party_member]
			var action = action_menus[party_member].selected as HeroBattler.Action
			hero.action = action
			prepare_action(action)
			print("Next action: ", action)
			
			
		
		"action_canceled":
			if %ActionState.current_state != $ActionState/ChooseAction:
				return
			
			var party_member = get_current_party_member()
			close_action_menu(party_member)
			
			party_member -= 1
			
			var hero = hero_battlers[party_member]
			var action = action_menus[party_member].selected as HeroBattler.Action
			hero.action = HeroBattler.Action.FIGHT
			hero.preparing = false
			prepare_action(action,true)
			
			%TurnQueue.goto_prev_turn()
		
		"hero_action_chosen":
			hero_action_chosen()
		
		"tp_add":
			Party.tp += value
		
		"tp_sub":
			Party.tp -= value
		
		"target_changed":
			current_target = value
		
		"fight_minigame_start":
			var fight_minigame = spawn_element(preload("uid://he0wouxpjxmq")) # fight_minigame.tscn
			fight_minigame.enable(value)
		
		"spell_prepare":
			var current_spell = value
			current_spell_events.resize(3)
			var spell_event = setup_party_event(preload("res://battle/resources/events/be_action_spell.tres"))
			spell_event.data["tp"] = current_spell.tp_cost
			spell_event.data["spell"] = current_spell
			current_spell_events[get_current_party_member()] = spell_event
			
			if not current_spell.targets_own_party:
				%ActionState.action.emit("choose_enemy")
				$ActionState/ChooseEnemy.transitions["cancel"] = $ActionState/ChooseSpell
		
		"item_prepare":
			var current_item = value.duplicate()
			print(current_item)
			current_item_events.resize(3)
			var item_event = setup_party_event(preload("res://battle/resources/events/be_action_item.tres"))
			item_event.data["item"] = current_item
			item_event.data["index"] = PlayerInventory.items.find(value)
			item_event.data["ref"] = value
			current_item_events[get_current_party_member()] = item_event
			
			if current_item.targets_enemy:
				%ActionState.action.emit("choose_enemy")
				$ActionState/ChooseEnemy.transitions["cancel"] = $ActionState/ChooseItem
			else:
				%ActionState.action.emit("choose_hero")
				$ActionState/ChooseHero.transitions["cancel"] = $ActionState/ChooseItem
			

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		if %ActionState.current_state != $ActionState/ChooseAction:
			if %TurnQueue.current_turn.index < 4:
				await get_tree().physics_frame
				%ActionState.action.emit("cancel")

func get_current_party_member() -> int:
	var party_member: int = -1
	
	for ind in range(hero_battlers.size()):
		var hero = hero_battlers[ind]
		if not hero.preparing:
			party_member = ind
			break
	
	return party_member

#region ---------------------- Action menu
func open_action_menu(index: int):
	for i in %MenuParent.get_children():
		i.queue_free()
	var menu: ActionMenu = action_menus[index]
	menu.activate()
	EventBus.actor_do_action.emit(Party.hero[get_current_party_member()].character_id,"idle")


func close_action_menu(index: int):
	var menu: ActionMenu = action_menus[index]
	menu.deactivate()


func freeze_action_menu(index: int):
	var menu: ActionMenu = action_menus[index]
	menu.freeze()


func unfreeze_action_menu(index: int):
	var menu: ActionMenu = action_menus[index]
	menu.unfreeze()
#endregion


#region ---------------------- Menu
func open_menu(new_menu: PackedScene) -> void:
	close_current_menu()
	
	var inst = new_menu.instantiate()
	%MenuParent.add_child(inst)
	switch_to_menu(inst)


func switch_to_menu(menu: Node) -> void:
	close_current_menu()
	
	if menu is ActionMenu:
		%DialogueBox.visible = true
	else:
		%DialogueBox.visible = false
	menu.visible = true
	
	Menu.open(menu, false)
	if "options_parent" in menu:
		Menu.hook_cursor(menu.options_parent,Menu.Layout.VERTICAL)


func close_current_menu() -> void:
	if Menu.current_menu:
		if Menu.current_menu is not ActionMenu:
			Menu.current_menu.queue_free()
		Menu.close()
	
	#for i in %MenuParent.get_children():
		#i.queue_free()
	
	%DialogueBox.visible = false

func clear_menus() -> void:
	for i in %MenuParent.get_children():
		i.queue_free()

func spawn_element(new_element: PackedScene) -> Node:
	close_current_menu()
	
	var inst = new_element.instantiate()
	%MenuParent.add_child(inst)
	element = inst
	return element
#endregion


#region ---------------------- Hero actions
func reset_hero_battlers() -> void:
	for ind in range(hero_battlers.size()):
		var hero = hero_battlers[ind]
		hero.action = hero.Action.FIGHT
		action_menus[ind].selected = 0
		hero.preparing = false
		hero.finished = false
		EventBus.actor_do_action.emit(hero.character_id,"idle")

	for i in action_menus:
		change_icon.emit(i,1)
		current_option = 0
		current_target = 0
		current_item_events.clear()
		current_spell_events.clear()

func prepare_action(action: HeroBattler.Action, undo: bool = false):
	match action:
		HeroBattler.Action.FIGHT, HeroBattler.Action.MERCY:
			%ActionState.action.emit("enemy_choice")
		
		HeroBattler.Action.MAGIC:
			%ActionState.action.emit("magic")
			if undo:
				var event = current_spell_events[get_current_party_member()]
				%EventQueue.add_event(event,undo)
				current_spell_events[get_current_party_member()] = null
		
		HeroBattler.Action.ITEM:
			%ActionState.action.emit("item")
			if undo:
				var event = current_item_events[get_current_party_member()]
				%EventQueue.add_event(event,undo)
				PlayerInventory.items.insert(event.data["index"],event.data["item"])
				current_item_events[get_current_party_member()] = null
		
		HeroBattler.Action.DEFEND:
			var event = setup_party_event(preload("res://battle/resources/events/be_action_defend.tres"))
			%EventQueue.add_event(event,undo)
			if not undo: 
				hero_action_chosen()


func hero_action_chosen() -> void:
	var party_member = get_current_party_member()
	var hero = hero_battlers[party_member]
	var action = action_menus[party_member].selected as HeroBattler.Action
	
	var action_icon: int = 0
	var action_str: = "idle"
	
	match action:
		HeroBattler.Action.FIGHT:
			action_str = "fight_prepare"
			var event = setup_party_event(preload("res://battle/resources/events/be_action_fight.tres"))
			%EventQueue.add_event(event)
			action_icon = 3
			
		HeroBattler.Action.MERCY:
			var event = setup_party_event(preload("res://battle/resources/events/be_action_mercy.tres"))
			%EventQueue.add_event(event)
			action_icon = 10
			
		HeroBattler.Action.DEFEND:
			action_str = "defend"
			action_icon = 7
		
		HeroBattler.Action.MAGIC:
			action_str = "magic_prepare"
			var event = current_spell_events[get_current_party_member()]
			%EventQueue.add_event(event)
			action_icon = 5
		
		HeroBattler.Action.ITEM:
			action_str = "item_prepare"
			var event = current_item_events[get_current_party_member()]
			%EventQueue.add_event(event)
			if PlayerInventory.items.has(event.data["ref"]):
				PlayerInventory.items.erase(event.data["ref"])
			action_icon = 6
	
	change_icon.emit(action_menus[party_member], action_icon)
	EventBus.actor_do_action.emit(Party.hero[party_member].character_id,action_str)
	
	hero.preparing = true
	close_action_menu(party_member)
	await get_tree().physics_frame
	%TurnQueue.goto_next_turn()


func setup_party_event(event: BattleEvent) -> BattleEvent:
	var new_event: BattleEvent = event.duplicate_deep()
	new_event.resource_local_to_scene = true
	
	if "party_member" in new_event.data.keys():
		new_event.data.set("party_member", get_current_party_member())
		
	if "target" in new_event.data.keys():
		new_event.data.set("target", current_target)
		
	if "option" in new_event.data.keys():
		new_event.data.set("option", current_option)
	
	return new_event


func do_party_actions() -> void:
	%ActionState.change_state($ActionState/Idle)
	
	for i in range(action_menus.size()):
		close_action_menu(i)
	
	close_current_menu()
	
	%DialogueBox.show()
	%EventQueue.execute_events()
	await %EventQueue.events_finished
	%TurnQueue.goto_next_turn()
#endregion


#region ---------------------- Attacks
func attack_anim_end() -> void:
	pass


func attack() -> void:
	pass


func attack_anim_start() -> void:
	pass
#endregion
