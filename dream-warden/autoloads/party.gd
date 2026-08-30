extends Node

signal hero_updated(hero: Array[CharacterStats])
signal enemy_updated(enemy: Array[CharacterStats])

var hero: Array[CharacterStats] = [preload("uid://b43pqrbag27nj"), preload("uid://b43pqrbag27nj"), preload("uid://b43pqrbag27nj")]:
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
