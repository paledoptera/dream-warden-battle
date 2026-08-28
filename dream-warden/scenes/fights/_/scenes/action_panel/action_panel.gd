class_name ActionPanel extends Node2D

@export var identifier: int = 0
@export var actions: Node2D
@export var action_menus: Array[ActionMenu]
var current_action_menu: ActionMenu
@export var enemy_selection: EnemySelection
@export var spell_selection: SpellSelection
@export var item_selection: ItemSelection
var cached_option: int = 0

signal switch_to_menu(menu: Node)
signal close_current_menu

func slide_down() -> Tween:
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(position.x,481.0),0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	return tween

func hide_health() -> void:
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(0.0,520.0),0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func _on_battle_state_changed(new_state: BattleTurnState.State):
	match new_state:
		BattleTurnState.State.CHOOSE_ACTION:
			# Handled by _on_party_action_choice_entered
			pass
		
		BattleTurnState.State.CHOOSE_ENEMY:
			current_action_menu.freeze()
			switch_to_menu.emit(enemy_selection)
			enemy_selection.refresh()
			Menu.hook_cursor(enemy_selection.options_parent,Menu.Layout.VERTICAL)
			
		BattleTurnState.State.CHOOSE_SPELL:
			current_action_menu.freeze()
			switch_to_menu.emit(spell_selection)
			spell_selection.refresh()
		
		BattleTurnState.State.CHOOSE_ITEM:
			current_action_menu.freeze()
			switch_to_menu.emit(item_selection)
			item_selection.refresh()
		
		BattleTurnState.State.CHECK_PARTY:
			pass
		
		BattleTurnState.State.HERO_ACTION:
			close_current_menu.emit()
			current_action_menu.cached_option = 0
			current_action_menu.selected = 0
			current_action_menu.deactivate()
			Dialogue.clear_text.emit()
			$DialogueBox.visible = true

func _on_party_action_choice_entered(party_member: int, party_actions: Array[BattleTurnState.Action]):
	if current_action_menu:
		current_action_menu.deactivate()
		current_action_menu.cached_option = Menu.selected
	
	var menu = action_menus[party_member]
	menu.activate()
	menu.unfreeze()
	switch_to_menu.emit(menu)
	var option = menu.cached_option
	Menu.hook_cursor(menu.actions_parent,Menu.Layout.HORIZONTAL,option)
	current_action_menu = menu
