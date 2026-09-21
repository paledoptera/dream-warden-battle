extends Node2D


const CAT_COLLECTIBLE = preload("uid://c4xirgxvxcybl")

var beat: float = 0.0

func _init() -> void:
	Party.enemy.clear()
	Party.hero.clear()
	Party.hero = [preload("uid://xcpu86gdep5b")] # hero_dess

func _ready() -> void:
	Music.beat.connect(spawn_cat_collectible)

func spawn_cat_collectible() -> void:
	print("BEAT, ", Music.last_beat)
	beat += 1.0
	
	if beat >= 4.0:
		beat -= 4.0
		var chance = [false, false, true].pick_random()
		if not chance:
			return
		
		
		var cat = CAT_COLLECTIBLE.instantiate()
		add_child(cat)
		cat.global_position.x = 700.0
		cat.global_position.y = randf_range(0.0,480.0)
