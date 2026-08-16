extends Node2D
@export var health_bar: ProgressBar
var hero
var fade_out = 0.0
var fade_out_internal = 0.0
var transitioning: float = 0.0
var fading_in: bool = false

func _ready() -> void:
	if not Battle.fight_scene:
		return
	hero = Battle.heroes[0]
	update_hp_values()
	hero.hp_changed.connect(_on_hp_changed)

func _process(delta: float) -> void:
	if fade_out_internal == 0.0:
		if not fading_in:
			transitioning += delta
			if transitioning > 0.3:
				transitioning -= 0.3
				if fade_out_internal != 1.0:
					fading_in = true
		else:
			fade_out = lerp(fade_out,fade_out_internal,0.5)
	elif fade_out_internal == 1.0:
		fading_in = false
		fade_out = lerp(fade_out,fade_out_internal,0.5)

	modulate = Color.WHITE.lerp(Color("ffffff00"),fade_out)

func update_hp_values() -> void:
	health_bar.min_value = 0
	health_bar.max_value = hero.hp_max
	health_bar.value = hero.hp

func _on_hp_changed(new_hp: int) -> void:
	health_bar.value = new_hp

func _on_rolling_changed(new_val: bool) -> void:
	if new_val:
		fade_out_internal = 1.0
	else:
		fade_out_internal = 0.0
