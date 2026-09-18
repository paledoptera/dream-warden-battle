extends Actor

const RUDEBUSTER_ANIM = preload("uid://dy2gem51jab0k")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "rude_buster":
		$AnimationPlayer.play("idle")

func play_rudebuster_sound() -> void:
	Sound.play(preload("uid://b1b6o1bp1u6f1"))
	
func play_rudebuster_hit_sound() -> void:
	Sound.play(preload("uid://dvuvxfskkh7fn"))

func spawn_rudebuster_animation() -> void:
	var anim = RUDEBUSTER_ANIM.instantiate()
	add_child(anim)
	anim.set_target(target)
