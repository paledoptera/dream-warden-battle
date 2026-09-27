extends Node

const CAROUSEL_6 = preload("uid://cw522dwinyrlv")
const CAROUSEL_6_MIDDLE = preload("uid://do3e5hqcv670r")

@export var debug: bool = false
var layers: Array[AquaLilypadLayer]
var lilypads: Array[AquaLilypad]

var carousel: AquaCarousel

func _ready() -> void:
	Fader.fade_out(0.5,Color.WHITE,Tween.EaseType.EASE_OUT,Tween.TransitionType.TRANS_CUBIC)
	change_carousel(CAROUSEL_6_MIDDLE)
	%Boss.player = %Player3D
	%Boss.look_target = %Player3D
	$Healthbar.player_3d = %Player3D
	EventBus.damage_player.connect(_damage_player)

func _process(delta: float) -> void:
	var player_xz_position = Vector3(%Player3D.global_position.x,0.0,%Player3D.global_position.z)
	%CameraArm.look_at(player_xz_position)
	$AttackOverlay.modulate = Color("ffffff00").lerp(Color("ffffff84"),%Player3D.danger_alpha)
	

func change_carousel(new_carousel: PackedScene):
	var inst = new_carousel.instantiate()
	
	if inst is not AquaCarousel:
		return
	
	if carousel:
		carousel.queue_free()
	carousel = inst
	add_child(carousel)
	carousel.position = Vector2(320.0,240.0)
	carousel.current_lilypad_changed.connect(_on_current_lilypad_changed)
	carousel.lilypad_layer_changed_state.connect(_on_lilypad_layer_changed_state)
	
	if not debug:
		carousel.visible = false

	if lilypads:
		lilypads.clear()
	
	if layers:
		layers.clear()
	
	
	for layer in carousel.lilypad_layers:
		var layer_child_count = layer.get_child_count()
		for i in range(layer.get_child_count()):
			var lilypad = layer.get_child(i)
			if lilypad is not AquaLilypad:
				continue
			lilypad.left = layer.get_child(wrapi(i-1,0,layer_child_count))
			lilypad.right = layer.get_child(wrapi(i+1,0,layer_child_count))
			lilypads.append(lilypad)
		layers.append(layer)
	
	%CarouselAnimator.update_carousel(carousel, lilypads)

	if carousel.boss_layer:
		_on_lilypad_layer_changed_state(carousel.boss_layer,false)
	
	%Player3D.update_position(%CarouselAnimator.get_child(0),0.3)
	

func _on_current_lilypad_changed(lilypad: AquaLilypad, last_lilypad: AquaLilypad):
	
	print("Current lilypad changed from ", last_lilypad, " to ", lilypad)
	
	var roll_speed = 0.3667 / carousel.current_layer.travel_time
	%Player3D.roll_animation_speed = roll_speed
	
	Sound.play(preload("res://shared/sound_effects/snd_swing.wav"),0.1,randf_range(1.2,1.3))
	Sound.play(preload("res://shared/sound_effects/snd_petaldrain.wav"),0.65,randf_range(1.0,1.3))
	
	
	
	var lilypad_ind = lilypads.find(lilypad)
	%Player3D.update_position(%CarouselAnimator.display_lilypads[lilypad_ind],carousel.current_layer.travel_time, lilypad.edge_only)
	%CarouselAnimator.update_current_lilypad(lilypad,carousel.current_layer)


func _on_lilypad_layer_changed_state(lilypad_layer: AquaLilypadLayer, state: bool):
	match state:
		true:
			for i in lilypad_layer.get_children():
				i.modulate = Color.WHITE
				i.node_3d.set_active()
		false:
			for i in lilypad_layer.get_children():
				i.modulate = Color("976f306c")
				i.node_3d.set_inactive()
				


func _on_boss_attack_started(attackdata3d: AttackData3D) -> void:
	var attack_scene = attackdata3d.scene.instantiate()

	match attackdata3d.layer:
		AttackData3D.Layer.PLAYER:
			$PlayerViewport/SubViewport.add_child(attack_scene)
		AttackData3D.Layer.BOSS:
			$BossViewport/SubViewport.add_child(attack_scene)
	
	attack_scene.boss = %Boss
	attack_scene.carousel_animator = %CarouselAnimator
	attack_scene.carousel = carousel
	attack_scene.start(attackdata3d.length)


func _on_boss_vulnerability_state_changed(vulnerable: bool) -> void:
	carousel.boss_layer_change_state(vulnerable)
	pass # Replace with function body.

func _damage_player(value: int) -> void:
	Sound.play(preload("uid://cpo81emadro0k"))
	var target = Party.hero.pick_random()
	var damage = EnemyBulletFormula.calculate(value,Party.enemy[0],target)
	
	target.hp -= damage
	
	var damage_number = FloatingText.initialize_text(str(damage),Color.WHITE)
	%Player3D.trigger_damage_number(damage_number)
