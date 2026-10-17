extends Node3D
class_name BulletSpawner3D

signal bullet_spawned(bullet)
signal bullet_deleted(bullet)

@export var bullet: Array[PackedScene]

func spawn(spawn_position: Vector3 = global_position, parent: Node = get_parent()) -> Node:
	var bullet_inst = bullet.pick_random().instantiate()
	parent.add_child(bullet_inst)
	if spawn_position != Vector3(-1,-1,-1):
		bullet_inst.global_position = spawn_position
		bullet_inst.rotation = rotation
	
	var real_bullet_inst = find_bullet_inst(bullet_inst)
	bullet_spawned.emit(real_bullet_inst)
	real_bullet_inst.deleted.connect(bullet_delete)
	return bullet_inst

func bullet_delete(bullet):
	bullet_deleted.emit(bullet)

func find_bullet_inst(node: Node) -> Bullet3D:
	if node is Bullet3D:
		return node
	
	var bullet_inst: Bullet3D 
	for i in node.get_children():
		bullet_inst = find_bullet_inst(i)
		if bullet_inst:
			return bullet_inst
	
	return null
