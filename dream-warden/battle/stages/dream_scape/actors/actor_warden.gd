extends Actor


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"hurt", "hurt_hard":
			$AnimationPlayer.play("idle")
