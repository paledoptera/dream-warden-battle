extends Area3D

const JUMP_SPEED: float = 2.0
const GRAV_SPEED: float = 1.8

var current_lilypad: Node3D
var internal_position: Vector3
var y_position: float = 0.0
var y_velocity: float = 0.0
var is_grounded: bool = false
var is_jumping: bool = false
var is_rolling: bool = false
var is_attacking: bool = false
var midair_roll_used: bool = false
var attack_var: int = 1
var roll_animation_speed: float = 1.0
var afterimage_anim = 0
var move
var attack
var jump
var jump_held
var jump_release
var crouch

func _ready() -> void:
	internal_position = global_position

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	
	get_input()
	handle_jump(delta)
	handle_attack()
	
	global_position.y = y_position
	
	do_animations()
	animate_soul_afterimage()


func get_input() -> void:
	move = Input.get_axis("left","right")
	jump = Input.is_action_just_pressed("confirm")
	jump_held = Input.is_action_pressed("confirm")
	jump_release = Input.is_action_just_released("confirm")
	attack = Input.is_action_just_pressed("cancel")
	
	crouch = Input.is_action_pressed("down")


func handle_gravity(delta: float) -> void:
	if y_position == 0.0 and not is_grounded and not is_rolling:
		$AnimationPlayer.current_animation = "idle"
		is_grounded = true
		is_jumping = false
		y_velocity = 0.0
	
	if y_velocity != 0.0 and is_grounded:
		is_grounded = false
	
	var fall_speed = (y_velocity * delta) * 1.2
	if is_rolling:
		fall_speed /= 2
	y_position += fall_speed
	y_position = max(y_position,0.0)
	
	if not is_grounded:
		y_velocity -= (GRAV_SPEED * delta) * 3


func handle_jump(delta: float) -> void:
	if jump_release and is_jumping:
		if y_velocity > 0.0:
			y_velocity *= 0.25
		is_jumping = false
	
	if not is_grounded or is_jumping or is_rolling:
		return
	
	if jump:
		Sound.play(preload("res://shared/sound_effects/snd_smallswing.wav"),1.0,randf_range(0.9,1.1)) 
		is_jumping = true
		y_velocity = JUMP_SPEED
		midair_roll_used = false
		animate("jump")


func handle_attack() -> void:
	if is_attacking or not attack:
		return
	
	if is_rolling:
		return
	
	if attack:
		attack_var *= -1
	
	is_attacking = true
	Sound.play(preload("res://shared/sound_effects/snd_swing.wav"),0.6,randf_range(0.9,1.1))
	await get_tree().create_timer(0.2).timeout
	is_attacking = false


func update_position(new_lilypad: Node3D, time: float, edge_only: bool = false):
	var new_pos = new_lilypad.global_position
	if edge_only:
		new_pos = new_lilypad.global_position.move_toward(internal_position,0.1*new_lilypad.scale.x)
		print("old pos: ", internal_position, " new pos: ", new_pos)
		print("EDGING")
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self,"global_position",new_pos,time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	internal_position = new_lilypad.global_position
	
	is_rolling = true
	await get_tree().create_timer(time).timeout
	is_rolling = false
	current_lilypad = new_lilypad
	

func animate(anim_name: StringName, speed_scale: float = 1.0,restart_anim: bool = false):
	if $AnimationPlayer.current_animation == anim_name:
		if not restart_anim:
			return
	$AnimationPlayer.stop()
	$AnimationPlayer.speed_scale = speed_scale
	$AnimationPlayer.play(anim_name)

func do_animations():
	
	if is_rolling:
		animate("roll",roll_animation_speed)
		return
	
	if is_attacking:
		if attack_var == -1:
			animate("attack_1")
		else:
			animate("attack_2")
		return
	
	if not is_grounded:
		if y_velocity >= 0.0:
			$AnimationPlayer.play("jump")
		else:
			$AnimationPlayer.play("fall")
		return
	
	animate("idle")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	match anim_name:
		"roll_left":
			$AnimationPlayer.play("idle")
	pass # Replace with function body.


func animate_soul_afterimage() -> void:
	
	var sprite = $Pivot/Susie
	var sprite_soul = $Pivot/Susie/Soul
	var marker = $Pivot/Susie/LocalZmarker
	
	var aqua_afterimage = preload("uid://cev8j51xyelxs").instantiate()
	get_owner().add_child(aqua_afterimage)
	aqua_afterimage.global_position = sprite_soul.global_position
	#aqua_afterimage.global_position = aqua_afterimage.global_position.move_toward(marker.global_position,0.5)
	
	afterimage_anim += 1
	afterimage_anim = wrap(afterimage_anim,0,2)
