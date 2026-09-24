class_name AquaCarouselAnimator extends Node3D

var lilypads: Array[AquaLilypad]
var display_lilypads: Array[Node3D]

var current_lilypad: AquaLilypad

const LILYPAD_3D = preload("uid://dxrrej4kwvhng")


func update_carousel(new_lilypads: Array[AquaLilypad]):
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
		add_child(new_lilypad)
		display_lilypads.append(new_lilypad)
		i.node_3d = new_lilypad
	
	update_current_lilypad(lilypads[0])

func update_current_lilypad(new_lilypad: AquaLilypad):
	for i in display_lilypads:
		i.animate("idle")
	
	current_lilypad = new_lilypad
	current_lilypad.node_3d.animate("current")
	
	current_lilypad.left.node_3d.animate("next")
	current_lilypad.right.node_3d.animate("next")
