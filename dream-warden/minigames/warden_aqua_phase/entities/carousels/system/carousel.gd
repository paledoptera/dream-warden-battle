class_name AquaCarousel extends Sprite2D


@export var lilypad_layers: Array[AquaLilypadLayer]

signal current_lilypad_changed(lilypad: Node2D, last_lilypad: Node2D)

var current_lilypad: Node2D:
	set(value):
		current_lilypad_changed.emit(value, current_lilypad)
		current_lilypad = value
var current_layer: AquaLilypadLayer
var hop_cooldown: float = 0.0

var player_position: Vector2
var last_player_position: Vector2

func _ready() -> void:
	for i in get_children():
		if i is not AquaLilypadLayer:
			continue
		lilypad_layers.append(i)
	
	current_layer = lilypad_layers[0]
	current_lilypad = current_layer.lilypads[0]

	player_position = %Player.global_position
	last_player_position = player_position

func _process(delta: float) -> void:
	var horizontal_input = Input.get_axis("left","right")
	var vertical_input = Input.get_axis("up","down")
	
	hop_cooldown = move_toward(hop_cooldown,0.0,delta)
	
	if not hop_cooldown == 0.0:
		return
	
	
	if horizontal_input or vertical_input:
		hop_cooldown = current_layer.travel_time
		
		if vertical_input: 
			goto_vertical_lilypad(vertical_input)
		elif horizontal_input: 
			goto_horizontal_lilypad(horizontal_input)
		
		last_player_position = player_position
		var tween = create_tween()
		tween.tween_property(%Player,"global_position",current_lilypad.global_position,0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func goto_horizontal_lilypad(val: int):
	if current_lilypad.no_horizontal_movement:
		return
	
	var index = current_lilypad.get_index()
	var new_lilypad_index = index - val
	new_lilypad_index = wrapi(new_lilypad_index,0, current_layer.get_child_count())
	current_lilypad = current_layer.get_child(new_lilypad_index)
	current_layer.current = new_lilypad_index


func goto_vertical_lilypad(val: int):
	if current_layer.down_layer and val == 1:
		current_layer = current_layer.down_layer
		current_lilypad = current_layer.get_child(current_layer.current)
		return
	elif current_layer.up_layer and val == -1:
		current_layer = current_layer.up_layer
		current_lilypad = current_layer.get_child(current_layer.current)
		return
