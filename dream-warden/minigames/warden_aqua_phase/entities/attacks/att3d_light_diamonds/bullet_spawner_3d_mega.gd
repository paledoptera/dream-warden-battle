extends Node3D


@export var bullet: Array[PackedScene]
@export var spawnpoints: Array[Marker3D]
@export var speed_mult_min: float = 1.0
@export var speed_mult_max: float = 1.0
@export var amount_min: int = 1
@export var amount_max: int = 1



func spawn(spawn_position: Vector3 = global_position, aim_position:= Vector3.ZERO, parent: Node = get_parent()) -> Array[Node]:
	global_position = spawn_position
	
	if aim_position != Vector3.ZERO:
		look_at(aim_position)
	
	var amount: int = randi_range(amount_min,amount_max)
	
	
	var bullets: Array[Node]
	
	var spawnpoints_final = spawnpoints.duplicate()
	
	spawnpoints_final.shuffle()
	spawnpoints_final.resize(amount)
	
	for i in spawnpoints_final:
		var bullet_inst = bullet.pick_random().instantiate()
		parent.add_child(bullet_inst)
		bullets.append(bullet_inst)
		bullet_inst.global_position = i.global_position
		bullet_inst.global_rotation = i.global_rotation
		bullet_inst.speed_multiplier = randf_range(speed_mult_min,speed_mult_max)
	return bullets
