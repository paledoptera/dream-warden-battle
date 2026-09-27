class_name AquaBoss extends Node3D

signal attack_started(attackdata3d: AttackData3D)
signal vulnerability_state_changed(vulnerable: bool)

@export var attack_pool: AttackPool3D
var vulnerable: bool = false:
	set(value):
		vulnerable = value
		vulnerability_state_changed.emit(value)
var vulnerable_timer: float = 1.5
var following_target: bool = false
var look_target: Node3D
var look_target_y: float = 0.0
var attacks: Array = []
var player: Node3D
var siner: float = 0.0
var light_attack_count: int = 0
var attacked: bool = false
var stage: int = 0


func _process(delta: float) -> void:
	siner += delta
	var target_pos = 0.1 + Siner.get_sine(siner,0.065,4.0)
	var model = $Warden
	
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



func _on_state_entered(state: State, string_action: StringName) -> void:
	match state.name.to_lower():
		"idle":
			$AnimationPlayer.play("idle")
			following_target = true
			look_target = player
			await get_tree().create_timer(0.5).timeout
			$StateMachine.change_state(%LightAttacks)
		
		"lightattacks":
			light_attack_count = randi_range(attack_pool.light_count_min,attack_pool.light_count_max)
			while light_attack_count > 0:
				light_attack_count -= 1
				var attack = do_attack("light")
				await get_tree().create_timer(attack.length).timeout
			$StateMachine.change_state(%HeavyAttack)

		"heavyattack":
			var attack = do_attack("heavy")
			await get_tree().create_timer(attack.length).timeout
			$StateMachine.change_state(%Vulnerable)
		
		"vulnerable":
			attacked = false
			vulnerable = true
			vulnerable_timer = 1.5
			while vulnerable_timer > 0.0:
				await get_tree().process_frame
				vulnerable_timer -= get_process_delta_time()
				if attacked: 
					vulnerable_timer = 0.0
					$StateMachine.change_state(%Attacked)
					return
			vulnerable = false
			$StateMachine.change_state(%LightAttacks)
		
		"attacked":
			$AnimationPlayer.play("hurt")
			$AnimationPlayer.queue("idle")
			
			attacked = false
			
			match stage:
				0:
					Sound.play(preload("uid://dahvh0ihaifr2"))
					%BlockAnimation.play("block")
					await get_tree().create_timer(0.05).timeout
					Party.tp += 34
					Sound.play(preload("res://shared/sound_effects/snd_ward_deflect.wav"))
					trigger_damage_number(0.0)
			
			vulnerable = false
			await get_tree().create_timer(0.5).timeout
			$StateMachine.change_state(%LightAttacks)
			

			
func do_attack(type: String) -> AttackData3D:
	var attack: AttackData3D
	
	match type:
		"light":
			attack = attack_pool.light.pick_random()
		"heavy":
			attack = attack_pool.heavy.pick_random()
	
	if attack.boss_stops_following:
		following_target = false
	
	attack_started.emit(attack)
	return attack

func hit():
	attacked = true
	print("BOSS IS HIT")
	pass


func trigger_damage_number(damage: float = 0.0) -> void:
	var damage_number: FloatingText
	if damage == 0.0:
		damage_number = FloatingText.initialize_sprite(preload("uid://dypyfakfdgag2"),Vector2.ZERO,Color.WHITE)
	else:
		damage_number = FloatingText.initialize_text(str(damage),Color.WHITE)
	
	var screen_pos = self.get_viewport().get_camera_3d().unproject_position(self.global_position)
	screen_pos *= 2.0
	screen_pos += Vector2(0.0,-84)
	
	get_owner().add_child(damage_number)
	damage_number.global_position = screen_pos
	print("DAMAGED")
