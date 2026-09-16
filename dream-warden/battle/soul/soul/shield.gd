extends Node2D

var progress = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("confirm"):
		Party.tp -= 5
		Sound.play(preload("res://shared/sound_effects/snd_heavyswing.wav"),1.0,randf_range(1.0,1.5))
		$AnimationPlayer.stop()
		$AnimationPlayer.play("slash")
		$Slash.flip_h = not $Slash.flip_h
		$Axe.flip_v = not $Axe.flip_v
		$SlashAfterimage.flip_h = not $SlashAfterimage.flip_h


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is not Bullet:
		return
	
	var bullet: Bullet = area
	if bullet.attackable:
		Party.tp += bullet.graze_points
		Sound.play(preload("res://shared/sound_effects/snd_paperbreak.wav"),1.0,randf_range(1.0,1.5))
		Sound.play(preload("res://shared/sound_effects/snd_wingslash.wav"),0.5,randf_range(1.0,1.5))
		bullet.destroy()
		
