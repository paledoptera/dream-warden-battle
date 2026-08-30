class_name BattleNew extends Node2D

signal tp_changed(value: float)
signal change_icon(menu: ActionMenu, icon: int)

const DEFAULT_SOUL_SPEED: float = 120.0

var hero_battlers: Array[HeroBattler]
var enemy_battlers: Array[EnemyBattler]
var tp: float = 0.0:
	set(value):
		tp_changed.emit(value)
		tp = value
var soul_speed: float
var action_menus: Array[Node]
var element: Node


func _ready() -> void:
	soul_speed = DEFAULT_SOUL_SPEED
	tp = 0.0
	
	for hero in Party.hero:
		hero_battlers.append(HeroBattler.new())
		
	for enemy in Party.enemy:
		enemy_battlers.append(EnemyBattler.new())
	
	# Updating TP bar
	var tp_bar = get_tree().get_first_node_in_group("tp_bar")
	tp_changed.connect(tp_bar._update_tp)
	
	# Getting action menus
	action_menus = get_tree().get_nodes_in_group("action_menu")
	for i in range(action_menus.size()):
		action_menus[i].index = i
		change_icon.connect(action_menus[i].change_icon)
	
	# Signals
	EventBus.battle_event.connect(battle_event)

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
			%ActionState.action.emit("start")

		"reset_hero_battlers":
			for ind in range(hero_battlers.size()):
				var hero = hero_battlers[ind]
				hero.action = hero.Action.FIGHT
				action_menus[ind].selected = 0
				hero.preparing = false
				hero.finished = false
				for i in action_menus:
					change_icon.emit(i,1)
				print(hero, " has been reset")
#endregion


func get_current_party_member() -> int:
	var party_member: int = -1
	
	for ind in range(hero_battlers.size()):
		var hero = hero_battlers[ind]
		if not hero.preparing:
			party_member = ind
			break
	
	return party_member

func open_action_menu(index: int):
	for i in %MenuParent.get_children():
		i.queue_free()
	var menu: ActionMenu = action_menus[index]
	menu.activate()
	

func close_action_menu(index: int):
	var menu: ActionMenu = action_menus[index]
	menu.deactivate()

func freeze_action_menu(index: int):
	var menu: ActionMenu = action_menus[index]
	menu.freeze()

func unfreeze_action_menu(index: int):
	var menu: ActionMenu = action_menus[index]
	menu.unfreeze()

func battle_event(event: StringName, value: int) -> void:
	match event:
		"action_selected":
			var party_member = get_current_party_member()
			var hero = hero_battlers[party_member]
			var action = action_menus[party_member].selected as HeroBattler.Action
			hero.action = action
			prepare_action(action)
			print("Next action: ", action)
		
		"action_canceled":
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
			tp += value
		"tp_sub":
			tp -= value

func prepare_action(action: HeroBattler.Action, undo: bool = false):
	match action:
		HeroBattler.Action.FIGHT, HeroBattler.Action.MERCY:
			%ActionState.action.emit("enemy_choice")
			
		HeroBattler.Action.DEFEND:
			%EventQueue.add_event(preload("res://battle/resources/events/be_action_defend.tres"),undo)
			if not undo: 
				hero_action_chosen()
		

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


func spawn_element(new_element: PackedScene) -> void:
	close_current_menu()
	
	var inst = new_element.instantiate()
	%Menu.add_child(inst)
	element = inst

func hero_action_chosen() -> void:
	var party_member = get_current_party_member()
	var hero = hero_battlers[party_member]
	var action = action_menus[party_member].selected as HeroBattler.Action
	
	var action_icon: int = 0
	
	match action:
		HeroBattler.Action.FIGHT:
			action_icon = 3
		HeroBattler.Action.MERCY:
			action_icon = 10
		HeroBattler.Action.DEFEND:
			action_icon = 7
	
	change_icon.emit(action_menus[party_member], action_icon)
	
	hero.preparing = true
	close_action_menu(party_member)
	%TurnQueue.goto_next_turn()


func _on_action_state_event(event: StringName) -> void:
	match event:
		"freeze_action_menu":
			freeze_action_menu(get_current_party_member())
		
		"unfreeze_action_menu":
			unfreeze_action_menu(get_current_party_member())


		"show_flavor_text":
			%DialogueBox.show()
		
		"hide_flavor_text":
			%DialogueBox.hide()
		
		"menu_enemy_selection":
			open_menu(preload("uid://cnthh51l1n1ux")) # enemy_selection.tscn
		
		"clear_menus":
			for i in %MenuParent.get_children():
				i.queue_free()
		
		"close_current_menu":
			close_current_menu()

			
		

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		await get_tree().physics_frame
		%ActionState.action.emit("cancel")
