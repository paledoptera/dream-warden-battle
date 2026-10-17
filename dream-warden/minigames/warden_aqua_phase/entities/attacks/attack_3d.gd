class_name Attack3D extends Node3D


signal boss_aim_at(node3d: Node3D)

var bullets: Array
var boss: AquaBoss
var carousel: AquaCarousel
var carousel_animator: Node3D
@export var time: float = 10.0

func _process(delta: float) -> void:
	if not carousel:
		queue_free()
	
	time -= delta
	if time <= 0.0:
		queue_free()


func aim(node: Node3D, target: Node3D):
	var target_pos = target.global_position
	target_pos.y = 0.0
	node.look_at(target_pos)

func get_player_lilypad() -> Node3D:
	var lilypad = carousel.current_lilypad.node_3d
	print("TEST")
	return lilypad

func get_left_lilypad() -> Node3D:
	var lilypad = carousel.current_lilypad
	var left = lilypad.left.node_3d
	return left

func get_right_lilypad() -> Node3D:
	var lilypad = carousel.current_lilypad
	var left = lilypad.right.node_3d
	return left

func _on_bullet_spawned(bullet):
	bullets.append(bullet)

func _on_bullet_deleted(bullet):
	bullets.erase(bullet)
