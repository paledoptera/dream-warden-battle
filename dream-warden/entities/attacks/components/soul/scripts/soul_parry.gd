extends Soul
var shield_direction:= Vector2.ZERO
var last_direction := Vector2.RIGHT

func _physics_process(delta: float) -> void:
	super(delta)
	var direction = Input.get_vector("left","right","up","down")
	if direction != Vector2.ZERO:
		last_direction = direction

	shield_direction = shield_direction.slerp(last_direction,0.2)
	$Shield.look_at(global_position+shield_direction)
	
