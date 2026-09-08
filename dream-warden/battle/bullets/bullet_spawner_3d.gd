extends Node3D
class_name BulletSpawner3D

@export var bullet: Array[PackedScene]

func spawn(spawn_position: Vector3 = global_position, parent: Node = get_parent()) -> Node:
	var bullet_inst = bullet.pick_random().instantiate()
	parent.add_child(bullet_inst)
	if spawn_position != Vector3(-1,-1,-1):
		bullet_inst.global_position = spawn_position
		bullet_inst.rotation = rotation
	return bullet_inst
