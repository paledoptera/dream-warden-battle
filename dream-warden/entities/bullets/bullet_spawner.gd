extends Node2D
class_name BulletSpawner

@export var bullet: PackedScene
@export var add_velocity_min:= Vector2.ZERO
@export var add_velocity_max:= Vector2.ZERO
@export var speed_mult: float = 1.0

func spawn(spawn_position: Vector2 = global_position, parent: Node = get_parent()) -> Node:
	var bullet_inst = bullet.instantiate()
	parent.add_child(bullet_inst)
	if spawn_position != Vector2(-1,-1):
		var spawn_rot = self.global_rotation
		bullet_inst.global_position = spawn_position
		bullet_inst.global_rotation = spawn_rot
		
	
	if bullet_inst is Bullet:
		bullet_inst.velocity.x += randf_range(add_velocity_min.x,add_velocity_max.x)
		bullet_inst.velocity.y += randf_range(add_velocity_min.y,add_velocity_max.y)
		bullet_inst.velocity = bullet_inst.velocity.rotated(bullet_inst.global_rotation)
		bullet_inst.speed_multiplier = speed_mult
	return bullet_inst
