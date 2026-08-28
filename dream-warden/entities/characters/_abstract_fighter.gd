@abstract class_name AbstractFighter extends Node2D
@export var stats: CharacterStats

func create_floating_text_string(string: String, color: Color = Color.WHITE) -> void:
	var new_text := preload("uid://cmoaj8ubaywoh").instantiate()
	new_text.initialize_text(global_position, string, color)
	get_tree().current_scene.add_child(new_text)

func create_floating_text_sprite(texture: Texture2D, offset: Vector2 = Vector2.ZERO, color: Color = Color.WHITE) -> void:
	var new_text := preload("uid://cmoaj8ubaywoh").instantiate()
	new_text.initialize_sprite(global_position, texture, offset, color)
	get_tree().current_scene.add_child(new_text)
