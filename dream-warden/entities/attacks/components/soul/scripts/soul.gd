class_name Soul extends CharacterBody2D

@export var horizontal: bool = true
@export var vertical: bool = true
var i_frames = 0.0
var last_position: Vector2
var current_speed: float

func _enter_tree() -> void:
	Battle.soul = self

func _exit_tree() -> void:
	Battle.soul = null

func _physics_process(delta: float) -> void:
	last_position = global_position
	# Get input
	var direction_x := Input.get_axis("left", "right")
	var direction_y := Input.get_axis("up", "down")
	current_speed = Battle.soul_speed
	
	# "focus mode"
	if Input.is_action_pressed("cancel"):
		current_speed /= 2
	
	## add custom movement or soul mode stuff here
	custom_soul_movement(direction_x, direction_y)
	
	
	# Movement
	if direction_x and horizontal:
		velocity.x = direction_x * current_speed
	else:
		velocity.x = 0.0

	if direction_y and vertical:
		velocity.y = direction_y * current_speed
	else:
		velocity.y = 0.0
		


	# animation stuff
	process_i_frames(delta)

	# finalize movement
	move_and_slide()

func custom_soul_movement(direction_x: float, direction_y: float) -> void:
	pass

func process_i_frames(delta: float):
	if not i_frames:
		return
	elif i_frames == 40.0:
		i_frames = 39.99
		animate_i_frames()
		return
		
	i_frames = move_toward(i_frames,0.0,delta * 30.0)

func animate_i_frames() -> void:
	while i_frames > 0.0:
		await get_tree().create_timer(0.133).timeout
		$Sprite2D.self_modulate = Color("ffffff73")
		await get_tree().create_timer(0.133).timeout
		$Sprite2D.self_modulate = Color.WHITE
	$Sprite2D.self_modulate = Color.WHITE

func hurt(damage: int, ignore_iframes: bool = false):
	if i_frames > 0.0 and not ignore_iframes:
		return
	Battle.damage_hero(damage)
	i_frames = 40.0
