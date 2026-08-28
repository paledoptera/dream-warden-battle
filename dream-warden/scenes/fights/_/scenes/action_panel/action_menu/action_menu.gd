class_name ActionMenu extends Control

signal spawn_menu(menu: PackedScene)
signal selected_action_changed(new_action: int)

@export var hp: Label
@export var hp_max: Label
@export var health_bar: ProgressBar
@export var icon: Sprite2D
@export var actions_parent: Node2D

var active = false
var frozen = false
var actions: Array
var selected: int = 0
var cached_option: int = 0



var hero: Hero
		

func _ready() -> void:
	actions = $Actions.get_children()


func update_hp_values() -> void:
	hp.text = str(hero.hp)
	hp_max.text = str(hero.hp_max)
	health_bar.min_value = 0
	health_bar.max_value = hero.hp_max
	health_bar.value = hero.hp

func _on_hp_changed(new_hp: int) -> void:
	health_bar.value = new_hp
	hp.text = str(new_hp)

func activate() -> void:
	if active:
		return
	
	#icon.frame = 1
	#hero.is_defending = false
	
	set_process_unhandled_input(true)
	
	$AnimationPlayer.play("open")

	for i in actions:
		i.selected = false
	
	_on_selected_changed(cached_option,-1)

	active = true

func deactivate() -> void:
	if not active:
		return
	
	set_process_unhandled_input(false)
	$AnimationPlayer.play("close")
	for i in actions:
		i.selected = false
	
	active = false

func freeze() -> void:
	frozen = true

func unfreeze() -> void:
	frozen = false
	

func _on_selected_changed(current: int, previous: int) -> void:
	for i in actions:
		i.selected = false
	actions[current].selected = true
	cached_option = current

func _on_accepted() -> void:
	var action = selected as BattleTurnState.Action
	
	EventBus.battle_goto_next_phase.emit()
	return
	
	
	#
	#match action:
		#Battle.Action.FIGHT, Battle.Action.MAGIC:
			#spawn_menu.emit(preload("uid://cnthh51l1n1ux")) # enemy_selection.tscn
			#icon.frame = 3
			#freeze()
			#Menu.close()
		#
		#_:
			#Menu.close()
