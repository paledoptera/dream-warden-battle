class_name SoulOrange extends Soul

enum Direction { RIGHT, UP, LEFT, DOWN }
enum DashState {IDLE, CHARGING, DASHING}

@export var direction := Vector2.RIGHT
var orange_velocity := Vector2.ZERO
var orange_speed_base: float = 360
var orange_speed : float = 360
var dash_state := DashState.IDLE
var afterimage_offset: float = 0.5
var charge_max: float = 16.0
var charge_timer: float = 0.0
var dash_timer: float = 0.0
var dash_timer_target: float = 0.0
var dash_timer_max_visual: float = 0.0
var dash_flash: float = 0.0
var dash_flash_max: float = 0.0
var buffer: float = 0.33
var distance: float = 0.0

func _ready() -> void:
	direction = direction.normalized()
	look_at(global_position + direction)
	rotate(deg_to_rad(-90))
	
	if direction.x != 0.0:
		horizontal = false
	elif direction.y != 0.0:
		vertical = false
	
	global_position -= direction * 66.0

func custom_soul_movement(direction_x: float, direction_y: float) -> void:
	current_speed *= 2
	orange_velocity = direction * -orange_speed
	distance += orange_speed * get_physics_process_delta_time()
	print("DISTANCE: ", distance)
	if dash_state == DashState.CHARGING:
		orange_velocity *= 0.83333333
		current_speed *= 0.83333333


func _physics_process(delta: float) -> void:
	spawn_afterimages()
	
	if buffer > 0.0:
		buffer = move_toward(buffer,0.0,delta)
	else:
		handle_dash(delta)
	
	super(delta)

func spawn_afterimages() -> void:
	
	var afterimage = preload("uid://cwnac2qb2d3sg").instantiate()
	add_child(afterimage)
	afterimage.soul = self
	afterimage.global_position = global_position

func handle_dash(delta: float) -> void:
	if dash_state == DashState.IDLE:
		afterimage_offset = 0.5
		orange_speed = orange_speed_base
		if Input.is_action_pressed("confirm"):
			dash_state = DashState.CHARGING
	elif dash_state == DashState.CHARGING:
		charge_timer = move_toward(charge_timer, 16.0, 0.5);
		afterimage_offset = lerp(0.5,0.0,charge_timer/16.0)
		
		if Input.is_action_just_released("confirm"):
			var boost = (5+(charge_timer*0.5))
			print("BOOST: ", boost)
			boost = max(boost,7.0)
			
			orange_speed = orange_speed_base + boost*66
			
			dash_timer = 4.0 + charge_timer
			dash_timer = max(dash_timer,10.0)
			dash_timer_max_visual = dash_timer
			dash_flash_max = charge_timer
			print("dash_timer = ", dash_timer, "charge_timer", charge_timer)
			charge_timer = 0.0
			print("NEW SPEED = ", orange_speed)
			dash_state = DashState.DASHING
			Sound.play(preload("uid://bxcputrgmxarv"),0.5) #snd_chargeshot_fire
	
	if dash_state == DashState.DASHING:
		afterimage_offset = lerp(1.0,0.5,(20.0-(dash_timer))/20.0)
		dash_timer -= 30.0 * delta
		
		dash_flash = lerp(dash_flash_max,0.0,1.0-dash_timer/dash_timer_max_visual)
		
		orange_speed = lerp(orange_speed,orange_speed_base,0.05)
		
		if (dash_timer <= 0.0):
			dash_state = DashState.IDLE
