extends Node2D
class_name BulletSpawner

@export var bullet: PackedScene
@export var add_velocity_min:= Vector2.ZERO
@export var add_velocity_max:= Vector2.ZERO

func spawn(spawn_position: Vector2 = global_position, parent: Node = get_parent()) -> Node:
	var bullet_inst = bullet.instantiate()
	parent.add_child(bullet_inst)
	if spawn_position != Vector2(-1,-1):
		bullet_inst.global_position = spawn_position
	if bullet_inst is Bullet:
		bullet_inst.velocity.x += randf_range(add_velocity_min.x,add_velocity_max.x)
		bullet_inst.velocity.y += randf_range(add_velocity_min.y,add_velocity_max.y)

	return bullet_inst
