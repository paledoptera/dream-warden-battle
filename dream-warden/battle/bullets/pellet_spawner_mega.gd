extends Node2D
class_name BulletSpawnerMega

@export var bullet: PackedScene
@export var rare_bullet: PackedScene
@export var spawnpoints: Array[Marker2D]
@export var parent: Node
@export var speed_mult: float = 1.0
@export var sound: AudioStream

func spawn(spawn_position: Vector2 = global_position, aim_position:= Vector2.ZERO) -> Array[Node]:
	if aim_position != Vector2.ZERO:
		look_at(aim_position)
	
	global_position = spawn_position
	
	var bullets: Array[Node] = []
	
	if sound:
		Sound.play(sound,0.5)
	
	
	
	for i in spawnpoints:

			
		var spawn_pos = i.global_position
		var spawn_rot = i.global_rotation
		var bullet_inst
		if rare_bullet:
			var random_chance = randi_range(0,10)
			if random_chance < 3:
				bullet_inst = rare_bullet.instantiate()
			else:
				bullet_inst = bullet.instantiate()
		else:
			bullet_inst = bullet.instantiate()
		parent.add_child(bullet_inst)
		bullets.append(bullet_inst)
		bullet_inst.global_position = spawn_pos
		bullet_inst.global_rotation = spawn_rot
		bullet_inst.speed_multiplier = speed_mult
		print("speed mult: ", bullet_inst.speed_multiplier)
		bullet_inst.velocity = bullet_inst.velocity.rotated(bullet_inst.global_rotation)
	
	return bullets
