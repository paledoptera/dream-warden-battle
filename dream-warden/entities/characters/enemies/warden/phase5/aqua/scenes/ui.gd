extends Node2D

var scale_effect: float = 1.0
var tp: int = 0
var active: bool = false
@onready var start_pos := global_position

func _ready() -> void:
	Battle.tp_changed.connect(_update_tp)
	

func _update_tp(value: float) -> void:
	
	scale_effect += (value - tp)/50
	if value < 100.0:
		get_tree().paused = false
		active = false
		$Normal.visible = true
		$Active.visible = false
	else:
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = true
		active = true
		$Normal.visible = false
		$Active.visible = true

func _process(delta: float) -> void:
	
	
	
	scale_effect = lerpf(scale_effect,1.0,0.4)
	scale = Vector2.ONE * scale_effect
	
	if active:
		global_position = lerp(global_position,start_pos+Vector2(0.0,-60.0),0.2)
	else:
		global_position = lerp(global_position,start_pos,0.2)
		
	
	if Input.is_action_just_pressed("up"):
		Battle.tp += 10
	if Input.is_action_just_pressed("down"):
		Battle.tp -= 10
	
	tp = lerp(tp,int(Battle.tp),0.33)
	
	
	var progress_white := $Normal/ProgressWhite
	var progress_topper := $Normal/ProgressWhiteTopper
	var progress := $Normal/Progress
	
	progress_white.value = tp
	progress.value = lerp(progress.value,float(tp),delta*4.0)
	progress_topper.value = progress.value+2.5
