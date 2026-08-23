extends Node2D

signal ai_state_changed(state)

var velocity:= Vector2.ZERO
var bump_velocity := Vector2.ZERO
var state = -1
var dash = 0

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	$Timer.start(0.5)
	ai_state_changed.connect(_on_state_changed)
	ai_state_changed.emit(0)

func _process(delta: float) -> void:
	match state:
		0:
			if dash < 9:
				dash += 1
				$Warden.global_position = $Warden.global_position.lerp($SoulParry.global_position,0.1)
				velocity = velocity.lerp($Warden.global_position.direction_to($SoulParry.global_position) * 400.0,0.025)
			else:
				velocity = velocity.lerp(Vector2.ZERO,0.1)
			var dif = $SoulParry.global_position.x - $Warden.global_position.x
			dif = clamp(dif,-200,200)
			print(dif, "DIF")
			$Warden.global_position.x = lerp($Warden.global_position.x,$SoulParry.global_position.x-dif,0.5)
		1:
			var dif = $SoulParry.global_position.x - $Warden.global_position.x
			if abs(dif) < 200.0:
				$Warden.global_position.x = lerp($Warden.global_position.x,$Warden.global_position.x-dif,0.01)
			velocity.x = 0.0
			velocity = velocity.lerp(Vector2(0.0,$Warden.global_position.y).direction_to(Vector2(0.0,$SoulParry.global_position.y)) * 1000.0,0.01)
			
			$LightningAttack.global_position = $Warden.global_position
			$Warden.global_position.y = lerp($Warden.global_position.y,$SoulParry.global_position.y,0.1)
		2:
			velocity = velocity.lerp(Vector2.ZERO,0.1)
			pass
			
	$Warden.global_position += velocity * delta
	bump_velocity = bump_velocity.lerp(Vector2.ZERO,0.2)

func _on_timer_timeout() -> void:
	Sound.play(preload("res://shared/sound_effects/snd_knight_cut2.wav"))
	$Warden/BulletSpawnerMega.spawn()
	$Timer.start(2.0)
	pass # Replace with function body.

func _on_state_changed(value: int = 0):
	state = value
	
	$AnimationPlayer.play(str(state))
	
	match state:
		0:
			dash = 0
			await get_tree().create_timer(1.0).timeout
			ai_state_changed.emit(1)
		1:
			await get_tree().create_timer(2.0).timeout
			ai_state_changed.emit(2)
		2:
			$LightningAttack.look_at($SoulParry.global_position)
			await get_tree().create_timer(1.0667).timeout
			$Warden.global_position = $LightningAttack/Line2D.to_global($LightningAttack/Line2D.get_point_position(43))
			velocity = $SoulParry.global_position.direction_to($Warden.global_position) * 200.0
			await get_tree().create_timer(1.0).timeout
			ai_state_changed.emit(0)


func _on_rapid_timer_timeout() -> void:
	if state != 1:
		return
	
	$Warden/RapidBullets.look_at(Vector2($SoulParry.global_position.x,$Warden/RapidBullets.global_position.y))
	$Warden/RapidBullets.spawn($Warden/RapidBullets.global_position,self)
	
	pass # Replace with function body.
