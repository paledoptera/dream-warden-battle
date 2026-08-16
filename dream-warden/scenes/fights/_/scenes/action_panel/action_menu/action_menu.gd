class_name ActionMenu extends Control

signal spawn_menu(menu: PackedScene)
signal selected_action_changed(new_action: int)

@export var hp: Label
@export var hp_max: Label
@export var health_bar: ProgressBar
@export var icon: Sprite2D
@export var actions_parent: Node2D

var active = true
var frozen = false
var actions: Array
var selected: int = 0
var cached_option: int = 0



var hero: Hero
		

func _ready() -> void:
	actions = $Actions.get_children()
	actions[0].selected = true
	
	Battle.state_changed.connect(_on_battle_state_changed)


func update_hp_values() -> void:
	hp.text = str(hero.hp)
	hp_max.text = str(hero.hp_max)
	health_bar.min_value = 0
	health_bar.max_value = hero.hp_max
	health_bar.value = hero.hp

func _on_hp_changed(new_hp: int) -> void:
	health_bar.value = new_hp
	hp.text = str(new_hp)


func deactivate() -> void:
	if not active:
		return
	
	set_process_unhandled_input(false)
	$AnimationPlayer.play("close")
	for i in actions:
		i.selected = false
	
	active = false

func activate() -> void:
	if active:
		return
	
	icon.frame = 1
	hero.is_defending = false
	
	set_process_unhandled_input(true)
	
	$AnimationPlayer.play("open")
	actions[0].selected = true
	selected = 0
	active = true

func freeze() -> void:
	frozen = true

func unfreeze() -> void:
	frozen = false
	

func _on_battle_state_changed(new_state: Battle.State, last_state: Battle.State):
	match new_state:
		Battle.State.CHOOSE_ACTION:
			activate()
			unfreeze()
		Battle.State.CHOOSE_ENEMY, Battle.State.CHOOSE_SPELL, Battle.State.CHOOSE_ITEM:
			freeze()
		Battle.State.HERO_DIALOGUE, Battle.State.ENEMY_DIALOGUE, Battle.State.ATTACK_START:
			deactivate()

func _on_selected_changed(current: int, previous: int) -> void:
	actions[previous].selected = false
	actions[current].selected = true
	Battle.selected_action = current
	cached_option = current

func _on_accepted() -> void:
	var action = selected as Battle.Action
	
	if action == Battle.Action.DEFEND:
		Battle.tp += 32
		icon.frame = 7
		hero.is_defending = true
	
	Battle.goto_next_phase()
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
