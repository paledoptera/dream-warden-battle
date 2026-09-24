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

func _process(delta: float) -> void:
	var player_xz_position = Vector3(%Player3D.global_position.x,0.0,%Player3D.global_position.z)
	%CameraArm.look_at(player_xz_position)
	

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
	
	%CarouselAnimator.update_carousel(lilypads)
	

func _on_current_lilypad_changed(lilypad: AquaLilypad, last_lilypad: AquaLilypad):
	
	print("Current lilypad changed from ", last_lilypad, " to ", lilypad)
	
	var roll_speed = 0.3667 / carousel.current_layer.travel_time
	%Player3D.roll_animation_speed = roll_speed
	
	Sound.play(preload("res://shared/sound_effects/snd_swing.wav"),0.1,randf_range(1.2,1.3))
	Sound.play(preload("res://shared/sound_effects/snd_petaldrain.wav"),0.65,randf_range(1.0,1.3))
	
	
	
	var lilypad_ind = lilypads.find(lilypad)
	%Player3D.update_position(%CarouselAnimator.display_lilypads[lilypad_ind],carousel.current_layer.travel_time, lilypad.edge_only)
	%CarouselAnimator.update_current_lilypad(lilypad)
