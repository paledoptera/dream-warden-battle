extends Node2D


const CAT_COLLECTIBLE = preload("uid://c4xirgxvxcybl")

func _init() -> void:
	Party.enemy.clear()
	Party.hero.clear()
	Party.hero = [preload("uid://xcpu86gdep5b")] # hero_dess


func spawn_cat_collectible() -> void:
	
	var chance = [false, false, true].pick_random()
	if not chance:
		return
	
	
	var cat = CAT_COLLECTIBLE.instantiate()
	add_child(cat)
	cat.global_position.x = 700.0
	cat.global_position.y = randf_range(0.0,480.0)
	

func _on_cat_collectible_timer_timeout() -> void:
	spawn_cat_collectible()
	pass # Replace with function body.
