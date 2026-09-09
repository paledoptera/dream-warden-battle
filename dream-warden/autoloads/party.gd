extends Node

signal hero_updated(hero: Array[CharacterStats])
signal enemy_updated(enemy: Array[CharacterStats])
signal tp_changed(value: float)

const DEFAULT_SOUL_SPEED: float = 120.0

var tp: float = 0.0:
	set(value):
		tp_changed.emit(value)
		tp = value

var soul_speed: float = DEFAULT_SOUL_SPEED
var soul_bearer: StringName = "susie" # this is for animations


var hero: Array[CharacterStats] = [preload("uid://b43pqrbag27nj")]:
	set(value):
		hero = value
		hero_updated.emit()

var enemy: Array[CharacterStats] = [preload("uid://dsnpoy8ro5it6")]:
	set(value):
		enemy = value
		enemy_updated.emit()
		

func add_hero(character: CharacterStats) -> void:
	hero.append(character)

func add_enemy(enemy: CharacterStats) -> void:
	enemy.append(enemy)

func get_target_hero(target: int) -> CharacterStatsHero:
	target = clampi(target,0,Party.hero.size()-1)
	return Party.hero[target]

func get_target_enemy(target: int) -> CharacterStatsEnemy:
	target = clampi(target,0,Party.enemy.size()-1)
	return Party.enemy[target]
