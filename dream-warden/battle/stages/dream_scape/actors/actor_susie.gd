extends Actor


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "rude_buster":
		$AnimationPlayer.play("idle")

func play_rudebuster_sound() -> void:
	Sound.play(preload("uid://b1b6o1bp1u6f1"))
