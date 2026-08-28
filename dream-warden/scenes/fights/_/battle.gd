class_name Battle extends Node2D

static var BATTLE_SCENE = preload("uid://d4km1k6q6wbdd")

@export var bgm: AudioStream
var turn_state := BattleTurnState.new()
var flags := BattleFlags.new()
var enemies: Array[CharacterStatsEnemy]
var element: Node



static func start(enemies: Array[CharacterStatsEnemy], stage: PackedScene, party: Array[CharacterStats] = Party.active_party) -> Node:
	var scene = SceneLoader.change_scene(BATTLE_SCENE)
	scene.enemies = enemies
	
	if party != Party.active_party:
		Party.active_party.clear()
		Party.active_party = party
	
	var stage_inst = stage.instantiate()
	scene.add_child(stage_inst)
	
	return scene


func _ready() -> void:
	Global.tp = 0.0
	Flags.set_flag("in_battle", true)
	
	if bgm:
		Music.play(bgm)
	
	turn_state.state_changed.connect(_on_state_changed)
	turn_state.state_changed.connect(%ActionPanel._on_battle_state_changed)
	turn_state.party_action_choice_entered.connect(%ActionPanel._on_party_action_choice_entered)
	
	EventBus.battle_goto_next_phase.connect(turn_state.goto_next_phase)
	EventBus.battle_goto_prev_phase.connect(turn_state.goto_prev_phase)
	EventBus.battle_flag_update.connect(set_flag)
	EventBus.reverse_action.connect(reverse_action)
	
	%ActionPanel.switch_to_menu.connect(switch_to_menu)
	
	turn_state.start()
	
func _exit_tree() -> void:
	Flags.set_flag("in_battle", false)

func _on_state_changed(new_state: BattleTurnState.State) -> void:
	if element:
		element.queue_free()
		element = null
	
	match new_state:
		BattleTurnState.State.CHOOSE_ACTION:
			pass
			# Looking for something? -> action_panel._on_party_action_choice_entered
		
		BattleTurnState.State.CHECK_PARTY:
			# This is the only action that can take place between party member actions,
			# because the tp you get from defending is sometimes needed
			# for your next party member's move
			
			var last_party_member := turn_state.current_party_member-1
			
			turn_state.cached_tp[last_party_member] = Global.tp
			print("CACHED TP:", turn_state.cached_tp)
			if turn_state.party_actions[last_party_member] == BattleTurnState.Action.DEFEND:
				action_defend()
			
			await get_tree().physics_frame
			EventBus.battle_goto_next_phase.emit()
		
		BattleTurnState.State.HERO_ACTION:
			var fight_queued: bool = false
			for i in turn_state.party_actions:
				match i:
					
					BattleTurnState.Action.FIGHT:
						spawn_element(preload("uid://he0wouxpjxmq")) # fight_minigame.tscn
					
					BattleTurnState.Action.MERCY:
						try_mercy()
					
					BattleTurnState.Action.DEFEND:
						queue_next_phase()
					
					BattleTurnState.Action.ITEM:
						queue_next_phase()

		
		BattleTurnState.State.DIALOGUE:
			display_dialogue()
			
		BattleTurnState.State.ATTACK_START:
			%UIAnimations.play("attack_fade")
		
		BattleTurnState.State.ATTACK_END:
			%UIAnimations.play_backwards("attack_fade")

		BattleTurnState.State.ATTACK_END:
			await get_tree().create_timer(0.2).timeout
			turn_state.current_turn += 1
			EventBus.battle_goto_next_phase.emit()


func display_flavor_text() -> void:
	var dialogue: DialogueString
	
	if turn_state.turn == 0:
		dialogue = enemies[0].get_opening_line()
	else:
		dialogue = enemies[0].get_flavor_text()
	
	dialogue = conditional_flavor_text(dialogue)
	
	Dialogue.display_text(dialogue)


func display_dialogue() -> void:
	var dialogue: DialogueBlock
	
	dialogue = enemies[0].get_dialogue()
	
	if not dialogue:
		await get_tree().physics_frame
		EventBus.battle_goto_next_phase.emit()
		return
	
	Dialogue.display_text(dialogue.text.duplicate_deep())
	await Dialogue.text_finished
	EventBus.battle_goto_next_phase.emit()


func conditional_flavor_text(dialogue: DialogueString) -> DialogueString:
	## This can be used to add (or use) conditional flavor text lines using simple flow charting.
	
	## For example: 
	#if Party.current_party[0].hp == 0:
		#dialogue = DialogueString.new("* Party member is down!")
	
	## Or this:
	#if tp > 80:
		#dialogue.text += "* You can use SUPER POWERFUL SPELL!"
	
	return dialogue


func switch_to_menu(menu: Node) -> void:
	close_current_menu()
	
	if menu is ActionMenu:
		%DialogueBox.visible = true
	else:
		%DialogueBox.visible = false
	menu.visible = true
	
	Menu.open(menu, false)


func close_current_menu() -> void:
	if Menu.current_menu:
		if Menu.current_menu is not ActionMenu:
			Menu.current_menu.visible = false
		Menu.close()
	%DialogueBox.visible = false


func spawn_element(new_element: PackedScene) -> void:
	close_current_menu()
	
	var inst = new_element.instantiate()
	$Menus.add_child(inst)
	element = inst


func try_mercy() -> void:
	if enemies[0].try_mercy():
		pass
	else:
		Dialogue.display_text(enemies[0].mercy_fail_text)
		await Dialogue.text_finished
		EventBus.battle_goto_next_phase.emit()

func action_defend() -> void:
	Global.tp += 32.0
	print(Global.tp)
	#icon.frame = 7
	#hero.is_defending = true

func set_flag(flag: StringName, value: Variant):
	flags.set_flag(flag,value)

func get_flag(flag: StringName) -> Variant:
	return flags.get_flag(flag)

func queue_next_phase() -> void:
	await get_tree().physics_frame
	EventBus.battle_goto_next_phase.emit()

func reverse_action(action: StringName) -> void:
	match action:
		"defend":
			Global.tp = turn_state.cached_tp[turn_state.current_party_member-1]
