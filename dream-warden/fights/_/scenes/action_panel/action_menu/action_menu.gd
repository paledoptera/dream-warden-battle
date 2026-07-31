class_name ActionMenu extends Control

@export var hp: Label
@export var hp_max: Label
@export var health_bar: ProgressBar
var active = true
var frozen = false
var actions: Array
var selected: int = 0:
	set(value):
		value = wrapi(value,0,5)
		actions[selected].selected = false
		actions[value].selected = true
		selected = value

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
	
	$AnimationPlayer.play("close")
	for i in actions:
		i.selected = false
	
	active = false

func activate() -> void:
	if active:
		return
	
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

func _unhandled_input(event: InputEvent) -> void:
	if not active and not frozen:
		return
	
	if not event.is_action("left") and not event.is_action("right") and not event.is_action("confirm"):
		return
	
	var last_selected = selected
	
	if event.is_action_pressed("left"):
		selected -= 1
	elif event.is_action_pressed("right"):
		selected += 1
	
	if last_selected != selected:
		Sound.play(preload("uid://con5cuooujhtc"))

	if event.is_action_pressed("confirm"):
		Sound.play(preload("uid://dhgp6ob58xc1m")) # snd_select.wav
