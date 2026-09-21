extends Node2D


var hitmarker_afterimage_timer: int = 0
var hitmarker_pos: int = 0
var accuracy: int = 0
var index: int = 0
var active: bool = true
var target: int = 0
@onready var hitmarker: Node = $HitMarker

func set_up(ind: int = 0):
	var position_markers: Array[Node] = $HitmarkerPositions.get_children()
	
	hitmarker.position = position_markers[ind].position

func create_afterimage() -> void:
	var inst = hitmarker.duplicate()
	add_child(inst)
	inst.global_position = hitmarker.global_position
	inst.modulate = Color("ffffff79")
	var tween = create_tween()
	tween.tween_property(inst,"modulate",Color("ffffff00"),0.3333)
	tween.tween_callback(inst.queue_free)

func move() -> void:
	if not active:
		return
	
	if hitmarker_afterimage_timer >= 2:
		hitmarker_afterimage_timer -= 2
		create_afterimage()
	
	hitmarker_afterimage_timer += 1
	hitmarker.position.x -= 7.0 * Engine.time_scale
	
	hitmarker_pos = int($HitMarker.position.x)

func check() -> bool:
	if hitmarker.position.x < 65.0:
		$HitMarker.visible = false
		return false
	
	return true

func press() -> bool:
	if hitmarker_pos > 205:
		return false
	
	active = false
	
	get_hit_accuracy()
	
	if accuracy == 150:
		$AnimationPlayer.play("perfect_hit")
		Sound.play(preload("res://shared/sound_effects/snd_criticalswing.wav"),0.5)
		
	else:
		$AnimationPlayer.play("hit")
	
	Sound.play(preload("res://shared/sound_effects/snd_laz.wav"))	
	
	do_attack()
	
	return true



func do_attack(miss: bool = false) -> void:
	
	var party_member = Party.hero[index]
	var enemy_target = Party.enemy[target]
	var attack_event = AttackEvent.new()
	
	
	attack_event.attacker = party_member
	attack_event.target = enemy_target
	attack_event.miss = miss
	
	if not miss:
		attack_event.damage = accuracy
		attack_event.damage_formula = PartyAttackFormula.new()
	
		var tp_gain = (float(accuracy)/150.0) * Flags.battle.attack_tp
		Party.tp += tp_gain
		
		if party_member.attack_effect:
			Actors.trigger_effect(enemy_target.character_id,party_member.attack_effect)
	else:
		attack_event.damage = 0
		
	
	Actors.do_action(party_member.character_id, "fight")
	

	await get_tree().create_timer(0.4).timeout
	EventBus.hero_attack.emit(attack_event)

	
func get_hit_accuracy() -> void:
	if hitmarker_pos >= 86.0 and hitmarker_pos <= 93.0 or round(hitmarker_pos) == 91.0:
		accuracy = 150
		hitmarker.position.x = 86.0
		hitmarker_pos = 86
		accuracy = 150
		
	else:
		var frames_off = abs(floor((float(hitmarker_pos)-91.0)/7))
		match frames_off:
			1.0:
				accuracy = 120
			2.0:
				accuracy = 110
			_:
				accuracy = 100.0-(frames_off*2)


func finished() -> void:
	var party_member = Party.hero[index]
	Actors.do_action(party_member.character_id, "idle")
