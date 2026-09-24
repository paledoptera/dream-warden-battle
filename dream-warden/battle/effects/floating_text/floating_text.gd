class_name FloatingText extends Node2D

const SCENE = preload("uid://cmoaj8ubaywoh")

static func initialize_text(text: String, color: Color) -> FloatingText:
	var new_text = SCENE.instantiate()
	
	var label = new_text.get_node("Container/RichTextLabel")
	label.text = text
	label.modulate = color
	
	return new_text

static func initialize_sprite(texture: Texture2D, offset: Vector2, color: Color) -> FloatingText:
	var new_text = SCENE.instantiate()
	
	var sprite = new_text.get_node("Container/Sprite2D")
	sprite.texture = texture
	sprite.offset = offset
	sprite.modulate = color

	return new_text
