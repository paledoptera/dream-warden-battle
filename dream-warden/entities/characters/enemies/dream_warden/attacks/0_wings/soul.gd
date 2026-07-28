class_name Soul extends CharacterBody2D

const SPEED = 120.0

@export var horizontal: bool = true
@export var vertical: bool = true

func _enter_tree() -> void:
	Battle.soul = self

func _exit_tree() -> void:
	Battle.soul = null

func _physics_process(delta: float) -> void:
	# Get input
	var direction_x := Input.get_axis("left", "right")
	var direction_y := Input.get_axis("up", "down")
	var current_speed := SPEED
	
	# "focus mode"
	if Input.is_action_pressed("cancel"):
		current_speed /= 2
	
	# Movement
	if direction_x and horizontal:
		velocity.x = direction_x * current_speed
	else:
		velocity.x = 0.0

	if direction_y and vertical:
		velocity.y = direction_y * current_speed
	else:
		velocity.y = 0.0
		

	## add custom movement or soul mode stuff here
	custom_soul_movement(direction_x, direction_y)

	# finalize movement
	move_and_slide()

func custom_soul_movement(direction_x: float, direction_y: float) -> void:
	pass
