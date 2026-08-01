extends Node2D

var scale_effect: float = 1.0
var tp: int = 0

func _ready() -> void:
	Battle.tp_changed.connect(_update_tp)
	

func _update_tp(value: float) -> void:
	
	scale_effect += (value - tp)/50
	if value == 100.0:
		$Normal.visible = true

func _process(delta: float) -> void:
	scale_effect = lerpf(scale_effect,1.0,0.4)
	scale = Vector2.ONE * 2 * scale_effect
	
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
	
