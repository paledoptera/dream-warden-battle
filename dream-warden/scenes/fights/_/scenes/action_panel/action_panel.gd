class_name ActionPanel extends Node2D

@export var actions: Node2D
@export var action_menu: ActionMenu
@export var enemy_selection: EnemySelection
@export var spell_selection: SpellSelection
var menu_is_temporary: bool = false
var element: Node
var cached_option: int = 0

func _ready() -> void:
	Battle.state_changed.connect(_on_battle_state_changed)

func slide_down() -> Tween:
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(position.x,481.0),0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	return tween

func hide_health() -> void:
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(0.0,520.0),0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func spawn_element(new_element: PackedScene) -> void:
	close_current_menu()
	
	var inst = new_element.instantiate()
	$Menus.add_child(inst)
	element = inst
	

func switch_to_menu(menu: Node) -> void:
	close_current_menu()
	
	if menu is ActionMenu:
		$DialogueBox.visible = true
	else:
		$DialogueBox.visible = false
	menu.visible = true
	
	Menu.open(menu, false)

func close_current_menu() -> void:
	if Menu.current_menu:
		if Menu.current_menu is not ActionMenu:
			Menu.current_menu.visible = false
			if menu_is_temporary:
				Menu.current_menu.queue_free()
				menu_is_temporary = false
		Menu.close()


func _on_battle_state_changed(new_state: Battle.State, last_state: Battle.State):
	if element:
		element.queue_free()
		element = null
	
	match new_state:
		Battle.State.CHOOSE_ACTION:
			if Battle.turn == 0:
				Dialogue.display_text.emit(Battle.get_opening_line())
			else:
				Dialogue.display_text.emit(Battle.get_flavor_text())
			switch_to_menu(action_menu)
			Menu.hook_cursor(action_menu.actions_parent,Menu.Layout.HORIZONTAL,action_menu.cached_option)
		
		Battle.State.CHOOSE_ENEMY:
			Dialogue.clear_text.emit()
			print("CLEARED!")
			switch_to_menu(enemy_selection)
			Menu.hook_cursor(enemy_selection.options_parent,Menu.Layout.VERTICAL)
	
		Battle.State.CHOOSE_SPELL:
			switch_to_menu(spell_selection)
			spell_selection.refresh()
		
		Battle.State.HERO_ACTION:
			close_current_menu()
			action_menu.cached_option = 0
			action_menu.selected = 0
			action_menu.deactivate()
			Dialogue.clear_text.emit()
			$DialogueBox.visible = true
			
			match Battle.selected_action:
				Battle.Action.FIGHT:
					spawn_element(preload("uid://he0wouxpjxmq")) # fight_minigame.tscn
				Battle.Action.MERCY:
					Battle.try_mercy()
		


func reset_action_menu() -> void:
	pass
	#if current_menu is not ActionMenu:
		#current_menu.queue_free()
		#current_menu = $Actions/ActionMenu
		#current_menu.unfreeze()
		#$DialogueBox.visible = true
