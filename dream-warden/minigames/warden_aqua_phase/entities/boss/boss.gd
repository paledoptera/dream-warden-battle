extends Node3D

var attacks: Array = []
var attack_pool: Array = [0, 1]

#
#func _on_bullet_timer_timeout() -> void:
	#var attack = attack_pool.pick_random()
	#attack = 1
	#var time: float = 0.5
	#match attack:
		#0: # lasers
			#var target = player.current_circle.sprite
			#instantiate_attack(preload("uid://dmlaifxf3g148"),target.global_position)
		#1: # diamond
			#var target = player.current_circle.sprite
			#$Targeter.look_at(target.global_position)
			#$Targeter.global_rotation.y -= deg_to_rad(180.0)
			#var bullet: Bullet3D = $BulletSpawner3D.spawn($BulletSpawner3D.global_position,get_parent())
			#
			#bullet.rotation.y = $Targeter.global_rotation.y
			#bullet.velocity = bullet.velocity.rotated(Vector3.UP,$Targeter.global_rotation.y)
	#
	#$BulletTimer.start(time)
#
#
#func instantiate_attack(scene: PackedScene, attack_position := Vector3.ZERO) -> void:
	#var attack := scene.instantiate()
	#
	#attacks_parent.add_child(attack)
	#attack.global_position = attack_position
	#
	#attacks.append(attack)
