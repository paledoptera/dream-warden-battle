extends Node2D

var start_point: Vector2 = Vector2(100.0,100.0)
var end_point: Vector2 = Vector2(200.0,100.0)
var progress: float = 0.0
@export var outline: Panel
@export var battlebox: PanelContainer
@export var battlebox_pivot: Node2D
@export var anim: AnimationPlayer
var full_frame: float = 0.0

func _process(delta: float) -> void:
	progress = move_toward(progress,8.0,1.0)
	$Soul.global_position = start_point.lerp(end_point,progress/8)
	
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
		outline_new.pivot_offset_ratio = Vector2(0.5,0.5)
		outline_new.z_index = 1
		outline_new.modulate = Color("ffffff80")
		var outline_tween = create_tween()
		outline_tween.tween_property(outline_new,"modulate",Color("ffffff00"),0.267)

func destroy() -> void:
	await get_tree().create_timer(0.5).timeout
	queue_free()
