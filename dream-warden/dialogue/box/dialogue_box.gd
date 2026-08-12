extends RichTextLabel

@export var effect_offset := Vector2.ZERO
var queue: Array[DialogueString]
var current: DialogueString


func _ready() -> void:
	Dialogue.display_text.connect(display_text)
	Dialogue.clear_text.connect(hide_text)

func _physics_process(_delta: float) -> void:
	if Dialogue.displaying_text and visible_ratio < 1.0:
		visible_characters += 1
		var c := text[visible_characters - 1].to_ascii_buffer()[0]
		if is_letter_or_number(c):
			Sound.play(preload("res://shared/sound_effects/snd_text.wav")) 
		if visible_ratio >= 1.0 and !current.require_input:
			check_if_text_finished(false)


func _unhandled_key_input(event: InputEvent) -> void:
	if not current:
		return
	if event.is_action("confirm") and event.is_pressed():
		if visible_ratio >= 1.0 and current.require_input and Dialogue.displaying_text:
			check_if_text_finished()


func display_text(p_dialogue: Variant) -> void:
	queue.clear()
	
	if p_dialogue is DialogueString:
		queue.append(p_dialogue.duplicate(true))
	elif p_dialogue is Array[DialogueString]:
		queue = p_dialogue.duplicate(true)
	elif p_dialogue is String:
		var new_dialogue = DialogueString.new()
		new_dialogue.text = p_dialogue
		queue.append(new_dialogue.duplicate(true))
	
	refresh()


func hide_text() -> void:
	visible_characters = 0
	Dialogue.displaying_text = false


func refresh() -> void:
	clip_children = CanvasItem.CLIP_CHILDREN_DISABLED
	for i in get_children():
		if i == $TypingSound:
			continue
		i.queue_free()
	current = queue.pop_front()
	text = current.text
	if current.markers.size() > 0:
		for marker in current.markers:
			add_marker(marker)
	Dialogue.displaying_text = true
	visible_characters = 1


func check_if_text_finished(hide: bool = true) -> void:
	if queue.size() > 0:
		refresh()
	else:
		Dialogue.text_finished.emit()
		if not hide:
			Dialogue.displaying_text = false
			return
		hide_text()


func add_marker(marker: DialogueMarker) -> void:
	
	
	
	if marker is GradientMarker:
		var gradient_eff = RichTextGradientEffect.new()
		gradient_eff.texture = marker.texture
		gradient_eff.start_char = marker.start_char
		gradient_eff.end_char = marker.end_char
		add_child(gradient_eff)
		gradient_eff.position = effect_offset
		
	if marker is SpriteMarker:
		var sprite_eff = RichTextSpriteEffect.new()
		sprite_eff.texture = marker.texture
		sprite_eff.start_char = marker.start_char
		sprite_eff.end_char = marker.end_char
		sprite_eff.sprite_scale = marker.sprite_scale
		sprite_eff.offset = marker.offset
		add_child(sprite_eff)
		sprite_eff.position = effect_offset


static func is_letter_or_number(p_char: int) -> bool:
	var is_letter := (p_char >= 65 and p_char <= 90) or (p_char >= 97 and p_char <= 122)
	var is_number := p_char >= 48 and p_char <= 57
	return is_letter or is_number
