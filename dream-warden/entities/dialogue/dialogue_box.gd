class_name DialogueBox
extends RichTextLabel

@export var identifier: StringName = ""
@export var effect_offset := Vector2.ZERO
var markers: Array[DialogueMarker]
var effects: Array[RichTextPlacementEffect]
var portrait: Sprite2D
var talksound: AudioStream = preload("res://shared/sound_effects/snd_text.wav")


func _ready() -> void:
	visible = false
	Dialogue.clear_text.connect(hide_text)
	Dialogue.refresh.connect(refresh)
	Dialogue.boxes.append(self)


func _process(_delta: float) -> void:
	
	if not visible:
		return
	
	if Dialogue.active and visible_ratio < 1.0:
		visible_characters += 1
		if not text:
			return
		
		if not visible:
			visible = true
		
		if self in Dialogue.current_boxes and not Dialogue.current.talksound_oneshot:
			var c := text[visible_characters - 1].to_ascii_buffer()[0]
			if is_letter_or_number(c):
				Sound.play(talksound) 
		
		#if visible_ratio >= 1.0 and !Dialogue.current.require_input:
			#check_if_text_finished(false)


func hide_text() -> void:
	visible_characters = 0
	clear_effects()
	text = ""
	visible = false
	
func clear_effects() -> void:
	for i in effects:
		if i:
			i.queue_free()
	effects.clear()

func refresh() -> void:
	clear_everything()
	
	if Dialogue.current.identifier != identifier:
		if self in Dialogue.current_boxes:
			Dialogue.current_boxes.erase(self)
			hide()
			return
	else:
		if self not in Dialogue.current_boxes:
			Dialogue.current_boxes.append(self)
			show()
	
	start_dialogue()
	


func start_dialogue() -> void:
	text = Dialogue.current.text
	
	if Dialogue.current.markers.size() > 0:
		for marker in Dialogue.current.markers:
			add_marker(marker)
	
	if Dialogue.current.portrait:
		if portrait:
			portrait.queue_free()
		portrait = Sprite2D.new()
		portrait.centered = false
		add_child(portrait)
		portrait.top_level = true
		portrait.global_position = global_position+Vector2(24.0,19.0)
		portrait.scale = Dialogue.current.portrait_scale
		portrait.z_index = 10
		portrait.texture = Dialogue.current.portrait
		offset_transform_enabled = true
		offset_transform_position.x = 114.0
	else:
		offset_transform_position.x = 0.0
	
	if Dialogue.current.talksound:
		talksound = Dialogue.current.talksound

	visible_characters = 1

func clear_everything() -> void:
	clear_effects()
	
	clip_children = CanvasItem.CLIP_CHILDREN_DISABLED
	
	for i in get_children():
		if i.is_in_group("textbox_comp"):
			continue
		i.queue_free()


func add_marker(marker: DialogueMarker) -> void:
	markers.append(marker)
	
	if marker is GradientMarker:
		var gradient_eff = RichTextGradientEffect.new()
		gradient_eff.texture = marker.texture
		gradient_eff.start_char = marker.start_char
		gradient_eff.end_char = marker.end_char
		add_child(gradient_eff)
		effects.append(gradient_eff)
		gradient_eff.position = effect_offset
		
	if marker is SpriteMarker:
		var sprite_eff = RichTextSpriteEffect.new()
		sprite_eff.texture = marker.texture
		sprite_eff.start_char = marker.start_char
		sprite_eff.end_char = marker.end_char
		sprite_eff.sprite_scale = marker.sprite_scale
		sprite_eff.offset = marker.offset
		add_child(sprite_eff)
		effects.append(sprite_eff)
		sprite_eff.position = effect_offset


static func is_letter_or_number(p_char: int) -> bool:
	var is_letter := (p_char >= 65 and p_char <= 90) or (p_char >= 97 and p_char <= 122)
	var is_number := p_char >= 48 and p_char <= 57
	return is_letter or is_number
