extends Area3D
class_name AquaPlayer

@export var attack_owner: Node3D
@export var anim: AnimationPlayer
@export var action_anim: AnimationPlayer
@export var current_circle: AquaCircle
@export var boss: Node3D

signal rolling_changed(new_val: bool)

var attacking: bool = false
var jumping: bool = false
var y_position: float = 0.0
var y_velocity: float = 0.0
var jump_speed: float = 2.0
var grav_speed: float = 0.18
enum State {GROUND, FALLING, JUMPING, CROUCHING, ATTACKING, ROLLING}
var state = State.GROUND
var airborne: bool = false
var move_speed: float = 2
var roll_direction = 0.0
var active: bool = true
var attack_var: int = 1
@export var bkg: Node3D

var invulnerable := false
var afterimage_anim = 0

var grounded: bool = false

var is_rolling: bool = false:
	set(value):
		is_rolling = value
		rolling_changed.emit(value)
var is_jumping: bool = false
var is_attacking: bool = false

var last_rolling: bool = false
var last_jumping: bool = false
var last_attacking: bool = false

var midair_roll_used: bool = false

var move
var attack
var jump
var jump_held
var jump_release
var crouch

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	handle_gravity(delta)
	
	if active:
		get_input()
		get_last()
		
		handle_roll()
		handle_jump()
		handle_attack()
	
		animate_soul_afterimage()
	
	animate_actions()
	
	
	global_position.y = y_position
	
	if $Pivot/Susie/Attack.has_overlapping_areas():
		for i in $Pivot/Susie/Attack.get_overlapping_areas():
			_on_attack_area_entered(i)
	
	if state != State.GROUND:
		return

#region Process function

func get_input() -> void:
	move = Input.get_axis("left","right")
	jump = Input.is_action_just_pressed("confirm")
	jump_held = Input.is_action_pressed("confirm")
	jump_release = Input.is_action_just_released("confirm")
	attack = Input.is_action_just_pressed("cancel")
	
	crouch = Input.is_action_pressed("down")

func get_last() -> void:
	last_rolling = is_rolling
	last_attacking = is_attacking
	last_jumping = is_jumping

func handle_roll() -> void:
	if is_rolling or move == 0.0:
		return
	
	if not grounded:
		if midair_roll_used:
			return
		else:
			midair_roll_used = true
	
	roll_direction = move
	
	is_rolling = true
	grounded = false
	y_velocity = 0.4
	
	#Sounds.play("snd_wing",0.3,randf_range(0.7,0.9))
	Sound.play(preload("uid://cihi8p7nv4w7g"),0.1,randf_range(1.2,1.3)) # snd_swing
	Sound.play(preload("uid://tbxowuw25v82"),0.65,randf_range(1.0,1.3)) # snd_petaldrain
	owner.shift_horizontal(roll_direction)
	await get_tree().create_timer(0.2).timeout
	grounded = true
	await get_tree().create_timer(0.1).timeout
	is_rolling = false
	

func handle_gravity(delta: float) -> void:
	if y_position == 0.0 and not grounded and not is_rolling:
		grounded = true
		is_jumping = false
		y_velocity = 0.0
	
	if y_velocity != 0.0 and grounded:
		grounded = false
	
	var fall_speed = y_velocity * delta
	if is_rolling:
		fall_speed /= 2
	y_position += fall_speed
	y_position = max(y_position,0.0)
	
	if not grounded:
		y_velocity -= (grav_speed)


func handle_jump() -> void:
	if jump_release and is_jumping:
		if y_velocity > 0.0:
			y_velocity *= 0.25
		is_jumping = false
	
	if not grounded or is_jumping:
		return
	
	if jump:
		Sound.play(preload("uid://c4147ge6tt2fq"),1.0,randf_range(0.9,1.1)) #snd_smallswing
		is_jumping = true
		y_velocity = jump_speed
		midair_roll_used = false

func handle_attack() -> void:
	if is_attacking or not attack:
		return
	
	if attack:
		attack_var *= -1
	
	is_attacking = true
	Sound.play(preload("uid://cihi8p7nv4w7g"),1.0,randf_range(0.9,1.1)) #snd_swing
	await get_tree().create_timer(0.2).timeout
	is_attacking = false

func animate_soul_afterimage() -> void:
	
	var sprite = $Pivot/Susie
	var sprite_soul = $Pivot/Susie/Soul
	var marker = $Pivot/Susie/LocalZmarker
	
	var aqua_afterimage = preload("uid://cev8j51xyelxs").instantiate()
	get_owner().add_child(aqua_afterimage)
	aqua_afterimage.global_position = sprite_soul.global_position
	aqua_afterimage.global_position = aqua_afterimage.global_position.move_toward(marker.global_position,0.5)
	
	if afterimage_anim == 0:
		var susie_afterimage = preload("uid://c17qdpeqluwmg").instantiate()
		get_owner().add_child(susie_afterimage)
		susie_afterimage.global_position = sprite.global_position
		susie_afterimage.global_position = susie_afterimage.global_position.move_toward(marker.global_position,0.5)
		susie_afterimage.global_position += Vector3(0.0,-0.035,0.0)
		susie_afterimage.animation = sprite.animation
		susie_afterimage.frame = sprite.frame
		susie_afterimage.offset = sprite.offset
		susie_afterimage.flip_h = sprite.flip_h
	
	afterimage_anim += 1
	afterimage_anim = wrap(afterimage_anim,0,2)



func animate_actions() -> void:
	if move == 0.0 and not is_jumping and not is_rolling and not is_attacking and grounded:
		animate("idle")
		return
	

	
	if is_rolling:
		if last_rolling != is_rolling:
			var anim_name = "roll_"
		
			if roll_direction == 1.0:
				anim_name += "right"
			elif roll_direction == -1.0:
				anim_name += "left"
		
			animate(anim_name,true)
			return
		return

	if is_attacking:
		if attack_var == -1:
			animate("attack_1")
		else:
			animate("attack_2")
		return
	
	if not grounded:
		if is_jumping:
			animate("jump")
		else:
			animate("fall")
#endregion

func animate_rudebuster() -> void:
	
	$Pivot/Susie/RudeBuster.position = Vector3.ZERO
	$Pivot/Susie/RudeBuster.visible = true
	var tween = create_tween()
	tween.tween_property($Pivot/Susie/RudeBuster,"global_position",boss.global_position,0.3)
	await tween.finished
	$Pivot/Susie/RudeBuster.visible = false


func playing_current_anims(arr: Array):
	for i in arr:
		if anim.current_animation == i and anim.is_playing():
			return true
	return false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"crouch":
			state = State.GROUND

func animate(anim_name: StringName, restart_anim: bool = false):
	if anim.current_animation == anim_name:
		if not restart_anim:
			return
	print("ANIM ", anim_name)
	if anim_name != "attack":
		$Pivot/Susie/Attack/CollisionShape3D.disabled = true
	anim.stop()
	anim.play(anim_name)

func animate_with_transition(trans_name: StringName, anim_name: StringName):
	if anim.current_animation == trans_name or anim.current_animation == anim_name:
		return
	anim.stop()
	anim.play(trans_name)
	anim.queue(anim_name)

func hurt(p_damage: int, ignore_iframes: bool = false) -> void:
	if not ignore_iframes:
		if invulnerable:
			return
	Battle.damage_hero(5 * p_damage)
	invulnerable_state()

func invulnerable_state()-> void:
	invulnerable = true
	var tween = get_tree().create_tween()
	tween.set_loops(3)
	tween.tween_property($Pivot/Susie/Soul, "modulate", Color("00ffff00"), 0.0)
	tween.tween_interval(0.1)
	tween.tween_property($Pivot/Susie/Soul, "modulate", Color("00ffff"), 0.0)
	tween.tween_interval(0.2)
	await tween.finished
	invulnerable = false


func _on_attack_area_entered(area: Area3D) -> void:
	if area is Bullet3D and area.parryable and is_attacking:
		if area.parry_break_sfx:
			Sound.play(area.parry_break_sfx)
		Battle.tp += area.parry_points
		area.destroy()


func _on_aqua_ui_active_changed(value: bool) -> void:
	active = not value


func _on_aqua_ui_action_done(value: int) -> void:
	match value:
		0:
			pass
		1:
			animate_rudebuster()
			
		2:
			pass
	pass # Replace with function body.
