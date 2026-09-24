class_name AquaBoss extends Node3D

signal attack_started(attackdata3d: AttackData3D)
var following_target: bool = false
var look_target: Node3D
var attacks: Array = []
var player: Node3D
var siner: float = 0.0
var light_attack_count: int = 0
@export var light_attacks: Array[AttackData3D]
@export var heavy_attacks: Array[AttackData3D]


func _process(delta: float) -> void:
	siner += delta
	var target_pos = 0.1 + Siner.get_sine(siner,0.065,4.0)
	var model = $warden/SubViewport/warden
	
	if following_target and look_target:
		$LookatBase.global_position = $LookatBase.global_position.slerp(look_target.global_position,0.2)
		model.look_at($LookatBase.global_position)
		target_pos += (look_target.global_position.y/3)
	
	model.global_position.y = lerpf(model.global_position.y,target_pos,0.09)



func _on_state_entered(state: State, string_action: StringName) -> void:
	match state.name.to_lower():
		"idle":
			following_target = true
			look_target = player
			await get_tree().create_timer(1.0).timeout
			$StateMachine.change_state(%LightAttacks)
		
		"lightattacks":
			light_attack_count = randi_range(1,3)
			while light_attack_count > 0:
				light_attack_count -= 1
				var attack = do_attack("light")
				await get_tree().create_timer(attack.length).timeout
			$StateMachine.change_state(%HeavyAttack)

		"heavyattack":
			var attack = do_attack("heavy")
			await get_tree().create_timer(attack.length).timeout
			$StateMachine.change_state(%Idle)

			
func do_attack(type: String) -> AttackData3D:
	var attack: AttackData3D
	
	match type:
		"light":
			attack = light_attacks.pick_random()
		"heavy":
			attack = heavy_attacks.pick_random()
	
	if attack.boss_stops_following:
		following_target = false
	
	attack_started.emit(attack)
	return attack
