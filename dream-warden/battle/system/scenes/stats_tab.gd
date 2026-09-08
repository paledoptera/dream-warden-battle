class_name StatsTab extends Control

@export var index: int = 0
var hero: CharacterStats

func _ready() -> void:
	if index >= Party.hero.size():
		hide()
		return
		
	
	
	hero = Party.hero[index]
	hero.hp_changed.connect(_update_hp)
	_update_hp()
	
	name = hero.name


func open() -> void:
	$AnimationPlayer.play("open")

func close() -> void:
	$AnimationPlayer.play("close")

func _update_hp(_new_hp: int = -1) -> void:
	%LabelHP.text = str(hero.hp)
	%LabelHPMax.text = str(hero.hp_max)
	%HealthBar.max_value = hero.hp_max
	%HealthBar.value = hero.hp
