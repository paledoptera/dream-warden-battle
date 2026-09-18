extends SubViewportContainer

var circles: Array
@export var player: Node3D
@export var stage: Node3D
@export var background: Node3D

func _ready() -> void:
	Party.tp = 0.0

func shift_horizontal(input: float = 0.0) -> void:
	circles.clear()
	for i in get_tree().get_nodes_in_group("aqua_circle"):
		circles.append(i)
	
	var current: AquaCircle = player.current_circle
	var next: AquaCircle
	
	var offset: float
	
	if input == 1.0 and current.right:
		next = current.right
		offset = current.right_dist
	elif input == -1.0 and current.left:
		next = current.left
		offset = -current.left_dist
	else:
		return
	
	print("OFFSET = ", offset)

	
	
	
	
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(stage,"rotation",stage.rotation+Vector3(0.0,deg_to_rad(offset),0.0),0.35).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(background,"rotation",background.rotation+(Vector3(0.0,deg_to_rad(offset)*0.75,0.0)),0.35).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(0.2).timeout
	
	for i in circles:
		i.sprite.modulate = i.default_color
		
	player.current_circle = next
	player.current_circle.sprite.modulate = AquaCircle.selected_color
	player.current_circle.left.sprite.modulate = AquaCircle.unselected_color
	player.current_circle.right.sprite.modulate = AquaCircle.unselected_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
