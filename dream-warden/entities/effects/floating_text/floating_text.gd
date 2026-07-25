extends Node2D

func initialize_text(init_position: Vector2, text: String, color: Color) -> void:
	var label = $Container/RichTextLabel
	global_position = init_position
	label.text = text
	label.modulate = color
	$Container/Sprite2D.queue_free()


func initialize_sprite(init_position: Vector2, texture: Texture2D, offset: Vector2, color: Color) -> void:
	var sprite = $Container/Sprite2D
	global_position = init_position
	sprite.texture = texture
	sprite.offset = offset
	sprite.modulate = color
	$Container/RichTextLabel.queue_free()
