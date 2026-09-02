class_name ActionMenu extends Control

signal hp_updated(hp: int)
signal hp_max_updated(hp_max: int)


@export var actions_parent: Node
var index: int = 0
var actions: Array
var active = false
var selected: int = 0
var hp = 0:
	set(value):
		hp = value
		hp_updated.emit(hp)
var hp_max = 0:
	set(value):
		hp_max = value
		hp_max_updated.emit(hp_max)


func _ready() -> void:
	
	hp_updated.connect(%LabelHP._on_hp_updated)
	hp_max_updated.connect(%LabelHPMax._on_hp_updated)
	
	actions = $Actions.get_children()
	Party.hero_updated.connect(hero_updated)


func activate() -> void:
	if active:
		return
	
	unfreeze()
	
	#icon.frame = 1
	#hero.is_defending = false
	
	set_process_unhandled_input(true)
	
	$AnimationPlayer.play("open")

	for i in actions:
		i.selected = false
	
	_on_selected_changed(selected,-1)

	active = true
	
	change_icon(self,1)


func deactivate() -> void:
	if not active:
		return
	
	set_process_unhandled_input(false)
	$AnimationPlayer.play("close")
	for i in actions:
		i.selected = false
	
	freeze()
	active = false


func freeze() -> void:
	Menu.close()

func unfreeze() -> void:
	Menu.open(self)
	Menu.hook_cursor(actions_parent,Menu.Layout.HORIZONTAL,selected)

func _on_selected_changed(current: int, previous: int) -> void:
	for i in actions:
		i.selected = false
	actions[current].selected = true


	

func _on_accepted() -> void:
	EventBus.battle_event.emit("action_selected",selected)

func _on_canceled() -> void:
	if index > 0:
		EventBus.battle_event.emit("action_canceled",0)
	
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


func hero_updated(heroes: Array[CharacterStats]) -> void:
	
	var hero = heroes[index]
	print("HERO: ", hero)
	%LabelName.text = hero.name.to_upper()
	hp = hero.hp
	hp_max = hero.hp_max
	
	%FrameLower.modulate = hero.color
	%FrameUpper.self_modulate = hero.color
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = hero.color
	%HealthBar.add_theme_stylebox_override("fill", style_box)
	
	

func change_icon(action_menu: ActionMenu, icon: int):
	if action_menu != self:
		return
	
	%Icon.frame = icon
	
	#
	#hp.text = str(hero.hp)
	#hp_max.text = str(hero.hp_max)
	#health_bar.min_value = 0
	#health_bar.max_value = hero.hp_max
	#health_bar.value = hero.hp
	#pass
#
#signal spawn_menu(menu: PackedScene)
#signal selected_action_changed(new_action: int)
#
#@export var hp: Label
#@export var hp_max: Label
#@export var health_bar: ProgressBar
#@export var icon: Sprite2D
#@export var actions_parent: Node2D
#
#var active = false
#var frozen = false
#var actions: Array
#var selected: int = 0
#var cached_option: int = 0
#
#
#
#var hero: Hero
		#
#
#func _ready() -> void:
	#actions = $Actions.get_children()
#
#
#func update_hp_values() -> void:
	#hp.text = str(hero.hp)
	#hp_max.text = str(hero.hp_max)
	#health_bar.min_value = 0
	#health_bar.max_value = hero.hp_max
	#health_bar.value = hero.hp
#
#func _on_hp_changed(new_hp: int) -> void:
	#health_bar.value = new_hp
	#hp.text = str(new_hp)
#

#func freeze() -> void:
	#frozen = true
#
#func unfreeze() -> void:
	#frozen = false
	#
#

#
