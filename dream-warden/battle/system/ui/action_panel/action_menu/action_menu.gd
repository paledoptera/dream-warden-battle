class_name ActionMenu extends Control

const SCENE = preload("uid://jeonilaut88t")

signal menu_opened
signal menu_closed
signal action_selected(action: int, option: int, target: int)
signal action_cancelled

var party_member: int = 0
var action: int = 0
var option: int = 0
var target: int = 0

var stats_tab: StatsTab

static func spawn() -> ActionMenu:
	var new_menu = SCENE.instantiate()
	return new_menu

func _ready() -> void:
	$MenuInputManager.open_menu($ChooseAction)

func _process(delta: float) -> void:
	if not stats_tab:
		return
		
	global_position = stats_tab.global_position

func select_action() -> void:
	action_selected.emit(action,option,target)
	$MenuInputManager.close_menu()


func _on_action_selected(selected_action: int) -> void:
	action = selected_action
	
	match action:
		0:
			$ChooseEnemy.refresh()
			%MenuInputManager.open_menu($ChooseEnemy)
			
		1:
			$ChooseSpell.index = party_member
			$ChooseSpell.refresh()
			%MenuInputManager.open_menu($ChooseSpell)
		2:
			%MenuInputManager.open_menu($ChooseItem)
		3:
			%MenuInputManager.open_menu($ChooseEnemy)
		4:
			actions_finalized()

func _on_option_selected(selected_option: int) -> void:
	
	option = selected_option
	
	match action:
		0, 4:
			option = -1
			return
		1: # magic
			var spell: Spell = Party.hero[party_member].spells[option]
			if spell.target == Enums.Target.HERO:
				%MenuInputManager.open_menu($ChooseHero)
			elif spell.target == Enums.Target.ENEMY:
				%MenuInputManager.open_menu($ChooseEnemy)
			
func _on_target_selected(selected_target: int) -> void:
	target = selected_target
	
	if action == 0 or action == 3:
		actions_finalized()
	if action == 1:
		actions_finalized()


func actions_finalized() -> void:
	%MenuInputManager.close_all_menus()
	action_selected.emit(action,option,target)

func actions_cancelled() -> void:
	action_cancelled.emit()


func _on_menu_input_manager_menu_opened() -> void:
	if %MenuInputManager.menu_stack.size() > 1:
		menu_opened.emit()
	else:
		menu_closed.emit()
