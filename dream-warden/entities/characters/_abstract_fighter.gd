
@abstract class_name AbstractFighter extends Node2D

signal hp_changed(new_hp: int)

@export var title := ""
@export_group("Stats")
@export var hp_max: int = 100
@export var defense: int = 0
@export var attack: int = 0
@export var magic: int = 0
@export_group("Equipment")
@export var weapon: Equippable
@export var armors: Array[Equippable]
@export_group("Misc")
@export var speechbubble_id: StringName = ""

var hp := 0:
	set(value):
		hp = value
		hp = clampi(hp,0,hp_max)
		hp_changed.emit(hp)

func _ready() -> void:
	hp = hp_max

func create_floating_text_string(string: String, color: Color = Color.WHITE) -> void:
	var new_text := preload("uid://cmoaj8ubaywoh").instantiate()
	new_text.initialize_text(global_position, string, color)
	get_tree().current_scene.add_child(new_text)

func create_floating_text_sprite(texture: Texture2D, offset: Vector2 = Vector2.ZERO, color: Color = Color.WHITE) -> void:
	var new_text := preload("uid://cmoaj8ubaywoh").instantiate()
	new_text.initialize_sprite(global_position, texture, offset, color)
	get_tree().current_scene.add_child(new_text)
