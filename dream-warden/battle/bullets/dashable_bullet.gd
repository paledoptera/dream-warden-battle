class_name DashableBullet extends Bullet

@export var dash_effect: PackedScene
@export var effect_offset:= Vector2.ZERO
@export var dash_sound: AudioStream

func _on_body_entered(body: Node2D) -> void:
	if body is SoulOrange:
		if body.dash_state == body.DashState.DASHING:
			if dash_effect:
				dash(body)
			if dash_sound:
				Sound.play(dash_sound)
			destroy()
			
			return
		
		body.hurt(damage,ignore_iframes)
		
		if destructible:
			destroy()

func dash(soul: SoulOrange) -> void:
	var particle = dash_effect.instantiate()
	get_parent().add_child(particle)
	particle.global_position = global_position + effect_offset
	particle.emitting = true
	
	soul.orange_speed = 1200
	soul.dash_timer = 20.0
	soul.dash_timer_max_visual = 20.0
	soul.dash_flash = 16.0
	soul.dash_flash_max = 16.0
