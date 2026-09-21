class_name SoulTransition extends Node2D

signal done

const SCENE = preload("uid://mmposqk66pey")

@export var outline: Panel
@export var battlebox: PanelContainer
@export var battlebox_pivot: Node2D
@export var anim: AnimationPlayer
var start_point: Vector2 = Vector2(100.0,100.0)
var end_point: Vector2 = Vector2(200.0,100.0)
var progress: float = 0.0
var full_frame: float = 0.0
var attack_scene: Node

static func create(attack_scene: Node) -> SoulTransition:
	var scene = SCENE.instantiate()
	scene.attack_scene = attack_scene
	
	return scene


func animate_soul_transition(end: bool = false) -> void:
	var anim = "in"
	var time = 0.6

	start_point = get_start_point()
	
	
	var soul = Tools.find_child_in_group(attack_scene,"soul")
	if soul:
		end_point = soul.position
		print("SOUL")
	
	var battlebox_inst = Tools.find_child_in_group(attack_scene,"battlebox")
	if battlebox_inst:
		battlebox.size = battlebox_inst.size
		battlebox.position = battlebox_inst.position
		
	
	$Shockwave1.position = start_point
	
	if end:
		start_point = end_point
		end_point = get_start_point()
		anim = "out"
		time = 0.4
		attack_scene.call_deferred("queue_free")
		$Shockwave1.position = end_point
	
	
	$AnimationPlayer.play(anim)
	await get_tree().physics_frame
	await get_tree().create_timer(time).timeout
	
	done.emit()
	
	if end:
		destroy()
	else:
		queue_free()


func _process(delta: float) -> void:
	progress = move_toward(progress,8.0,1.0)
	$Soul.position = start_point.lerp(end_point,progress/8)
	
	if progress < 1.0:
		return
	
		
	full_frame += delta
	if full_frame >= 0.033:
		full_frame -= 0.033
		var outline_new = outline.duplicate()
		$BattleboxPivot/Afterimages.add_child(outline_new)
		outline_new.size = battlebox.size
		outline_new.scale = battlebox.scale
		outline_new.rotation = battlebox.rotation
		outline_new.global_position = battlebox.global_position
		
		outline_new.pivot_offset_ratio = Vector2(0.0,0.0)
		outline_new.offset_transform_enabled = true
		outline_new.offset_transform_position_ratio = Vector2(-0.5,-0.5)
		outline_new.z_index = 1
		outline_new.modulate = Color("ffffff80")
		var outline_tween = create_tween()
		outline_tween.tween_property(outline_new,"modulate",Color("ffffff00"),0.267)

func destroy() -> void:
	await get_tree().create_timer(0.5).timeout
	queue_free()

func get_start_point() -> Vector2:
	var actor_name = Flags.battle.soul_bearer
	print("SOUL BEARER = ", actor_name)
	var actors = get_tree().get_nodes_in_group("actors")
	
	for i in actors:
		if i is not Actor:
			continue
		if i.id == actor_name:
			return to_local(i.global_position)
	return Vector2.ZERO
