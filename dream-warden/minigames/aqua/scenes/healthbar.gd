extends Node2D
@export var health_bar: ProgressBar
var player_3d: AquaPlayer3D
var hero
var fade_out = 0.0
var fade_out_internal = 0.0
var transitioning: float = 0.0
var fading_in: bool = false

func _ready() -> void:
	hero = Party.hero[0]
	update_hp_values()
	hero.hp_changed.connect(_on_hp_changed)

func _process(delta: float) -> void:
	modulate =Color("ffffff00").lerp(Color.WHITE,player_3d.danger_alpha)

func update_hp_values() -> void:
	health_bar.min_value = 0
	health_bar.max_value = hero.hp_max
	health_bar.value = hero.hp

func _on_hp_changed(new_hp: int) -> void:
	health_bar.value = new_hp

func _on_rolling_changed(new_val: bool) -> void:
	if new_val:
		fade_out_internal = 1.0
