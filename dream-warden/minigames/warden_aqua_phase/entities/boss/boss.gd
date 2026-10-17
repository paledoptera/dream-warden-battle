class_name AquaBoss extends Node3D

signal attack_started(attackdata3d: AttackData3D)
signal vulnerability_state_changed(vulnerable: bool)
signal stage_changed(stage: int)

const SPINNER = preload("uid://dbs4h6knd22x4")

@export var attack_pool: AttackPool3D

var vulnerable: bool = false:
	set(value):
		vulnerable = value
		vulnerability_state_changed.emit(value)
var invincibility_frames: float = 0.5
var following_target: bool = false
var look_target: Node3D
var look_target_y: float = 0.0
var attacks: Array = []
var player: Node3D
var siner: float = 0.0
var light_attack_count: int = 0
var attacking: bool = false
var stage: int = 0:
	set(value):
		stage = value
		stage_changed.emit(value)
		_on_stage_changed(value)
var shield_up: bool = true
var action_cancelled: bool = false
var spinner: Node3D
@onready var state_timer: float = 1.0


func _process(delta: float) -> void:
	siner += delta
	var target_pos = 0.1 + Siner.get_sine(siner,0.065,4.0)
	var model = $Warden
	
	for i in attacks:
		if not i:
			attacks.erase(i)
	
	
	
	if following_target and look_target:
		var follow_pos = look_target.global_position
		follow_pos.y = 0.0
		$LookatBase.global_position = $LookatBase.global_position.slerp(follow_pos,0.2)
		
		look_target_y = lerp(look_target_y,look_target.global_position.y,0.1)
		var look_at_pos = $LookatBase.global_position
		look_at_pos.y = look_target_y
		model.look_at(look_at_pos)
		target_pos += (look_target.global_position.y/3)
	
	model.global_position.y = lerpf(model.global_position.y,target_pos,0.09)
	
	invincibility_frames = move_toward(invincibility_frames,0.0,delta)
	
	if state_timer < 0.0:
		state_timer = 0.0
		match $StateMachine.current_state.name.to_lower():
			"idle":
				$StateMachine.change_state(%LightAttacks)
			
			"lightattacks":
				if light_attack_count > 0:
					light_attack_count -= 1
					do_attack("light")
				else:
					$StateMachine.change_state(%HeavyAttack)
			
			"heavyattack":
				$StateMachine.change_state(%Vulnerable)
			
			"vulnerable":
				if shield_up:
					vulnerable = false
				$StateMachine.change_state(%Idle)
	else:
		state_timer -= delta
	



func _on_state_entered(state: State, string_action: StringName) -> void:
	print("STATE ENTERED ", state.name)
	
	match state.name.to_lower():
		"idle":
			$AnimationPlayer.play("idle")
			following_target = true
			look_target = player
			state_timer = 0.5
			refresh_attack_pool()
			
		"lightattacks":
			do_attack("light")
		
		"heavyattack":
			do_attack("heavy")
		
		"vulnerable":
			attacking = false
			vulnerable = true
			state_timer = 1.5
			

			
func do_attack(type: String) -> AttackData3D:
	
	if not attacking:
		attacking = true
	
	var attack: AttackData3D
	
	match type:
		"light":
			attack = attack_pool.light.pick_random()
		"heavy":
			attack = attack_pool.heavy.pick_random()
	
	if attack.boss_stops_following:
		following_target = false
	
	attacks.append(attack)
	
	attack_started.emit(attack)
	state_timer = attack.length
	return attack

func hit():
	if stage == 1 and Party.enemy[0].hp <= 2500:
		mega_hit()
		return
	
	if invincibility_frames > 0.0 or not vulnerable:
		return
	
	$AnimationPlayer.play("hurt")
	$AnimationPlayer.queue("idle")
	
	match stage:
		0:
			block(34)

		1:
			invincibility_frames = 0.2
			Sound.play(preload("uid://dahvh0ihaifr2"))
			Sound.play(preload("uid://cl0ssn0jta65n"))
			trigger_damage_number(56.0)
			Party.enemy[0].hp -= 56.0
			vulnerable = false
			
			await get_tree().create_timer(1.0).timeout
			vulnerable = true
		
		2:
			block(10)
			
		3:
			
			vulnerable = false
		
			
	
	if shield_up:
		vulnerable = false

func mega_hit():
	get_owner().stage += 1
	$StateMachine.change_state(%Idle)
	vulnerable = false
	attacking = false
	if attacks:
		for i in attacks:
			if i.instance:
				i.instance.queue_free()
		attacks.clear()
	Sound.play(preload("res://shared/sound_effects/snd_prophecy_break.wav"),2.0)
	Sound.play(preload("res://shared/sound_effects/snd_ward_hardhit.wav"))

func trigger_damage_number(damage: float = 0.0) -> void:
	var damage_number: FloatingText
	if damage == 0.0:
		damage_number = FloatingText.initialize_sprite(preload("uid://dypyfakfdgag2"),Vector2.ZERO,Color.WHITE)
	else:
		damage_number = FloatingText.initialize_text(str(int(damage)),Color.WHITE)
	
	var screen_pos = self.get_viewport().get_camera_3d().unproject_position(self.global_position)
	screen_pos *= 2.0
	screen_pos += Vector2(0.0,-84)
	
	get_owner().add_child(damage_number)
	damage_number.global_position = screen_pos
	print("DAMAGED")

func _on_stage_changed(value: int):
	match stage:
		0:
			shield_up = true
		1:
			shield_up = false
			spinner = SPINNER.instantiate()
			add_child(spinner)
		2:
			shield_up = true
			spinner.queue_free()
			spinner = null

func block(tp_amount: int) -> void:
	invincibility_frames = 0.5
	Sound.play(preload("uid://dahvh0ihaifr2"))
	%BlockAnimation.play("block")
	await get_tree().create_timer(0.05).timeout
	Party.tp += tp_amount
	Sound.play(preload("res://shared/sound_effects/snd_ward_deflect.wav"))
	trigger_damage_number(0.0)

func refresh_attack_pool() -> void:
	match stage:
		0:
			attack_pool = preload("uid://c4hsbw7elydr4")
#
		1:
			attack_pool = preload("uid://cav4vi3medhed")
		
		2:
			attack_pool = preload("uid://dnox8odyohfkr")  #
	
	light_attack_count = randi_range(attack_pool.light_count_min,attack_pool.light_count_max)
