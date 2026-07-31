extends Node2D
class_name BulletSpawner

@export var bullet: PackedScene

func spawn(spawn_position: Vector2 = global_position, parent: Node = get_parent()) -> Node:
	var bullet_inst = bullet.instantiate()
	parent.add_child(bullet_inst)
	if spawn_position != Vector2(-1,-1):
		bullet_inst.global_position = spawn_position
	return bullet_inst
