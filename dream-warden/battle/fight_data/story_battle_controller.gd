class_name StoryBattleController extends Resource

signal finished

func player_turn_start() -> void:
	await Party.get_tree().physics_frame
	finished.emit()
	print("WOOH")

func player_turn_end() -> void:
	await Party.get_tree().physics_frame
	finished.emit()

func enemy_turn_start() -> void:
	await Party.get_tree().physics_frame
	finished.emit()

func _transform_enemy(enemy: CharacterStatsEnemy, into: CharacterStatsEnemy):
	var index = Party.enemy.find(enemy)
	var new_enemy = into
	new_enemy.hp = enemy.hp
	new_enemy.hp_max = enemy.hp_max
	Party.enemy.erase(enemy)
	Party.enemy.insert(index,new_enemy)


func _transform_hero(hero: CharacterStatsHero, into: CharacterStatsHero):
	var index = Party.hero.find(hero)
	var new_hero = into
	new_hero.hp = hero.hp
	new_hero.hp_max = hero.hp_max
	Party.hero.erase(hero)
	Party.hero.insert(index,new_hero)
