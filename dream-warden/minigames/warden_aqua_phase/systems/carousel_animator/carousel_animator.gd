class_name AquaCarouselAnimator extends Node3D

var lilypads: Array[AquaLilypad]
var display_lilypads: Array[Node3D]
var current_lilypad: AquaLilypad
var carousel: AquaCarousel
var player_3d: AquaPlayer3D

const LILYPAD_3D = preload("uid://dxrrej4kwvhng")
const LILYPAD_RUNAROUND_3D = preload("uid://b04510e6sryw")


func update_carousel(new_carousel: AquaCarousel, new_lilypads: Array[AquaLilypad]):
	carousel = new_carousel
	
	if display_lilypads:
		for i in display_lilypads:
			i.queue_free()
		display_lilypads.clear()
	
	lilypads = new_lilypads
	
	for i in lilypads:
		var new_lilypad = LILYPAD_3D.instantiate()
		var new_pos = (i.position/150.0)
		new_lilypad.position = Vector3(new_pos.x,0.0,new_pos.y)
		new_lilypad.scale = Vector3(i.scale.x,i.scale.y,i.scale.y)
		new_lilypad.lilypad = i
		add_child(new_lilypad)
		display_lilypads.append(new_lilypad)
		i.node_3d = new_lilypad
		
		if i is AquaLilypadRunaround:
			var new_runaround = LILYPAD_RUNAROUND_3D.instantiate()
			new_lilypad.add_child(new_runaround)
			new_runaround.lilypad = i
			new_runaround.player_3d = player_3d
			
	
	update_current_lilypad(lilypads[0], new_carousel.current_layer)

func update_current_lilypad(new_lilypad: AquaLilypad, layer: AquaLilypadLayer):
	for i in display_lilypads:
		i.animate("idle")
	
	if current_lilypad:
		current_lilypad.node_3d.hopped_off()
	
	current_lilypad = new_lilypad
	current_lilypad.node_3d.animate("current")
	current_lilypad.node_3d.hopped_onto()
	current_lilypad.left.node_3d.animate("next")
	current_lilypad.right.node_3d.animate("next")

func update_runaround_position(runaround_position: float):
	if current_lilypad is not AquaLilypadRunaround:
		return
	var runaround = current_lilypad.node_3d.get_node("LilypadRunaround3D")
	runaround.turner.rotation.y = (-runaround_position)-deg_to_rad(90.0)
