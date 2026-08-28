class_name TPBar extends Node2D

var tp: int = 0

func _ready() -> void:
	Global.tp_changed.connect(_update_tp)

func _update_tp(value: float) -> void:
	if value == 100.0:
		$Normal.visible = false
		$Max.visible = true
	else:
		$Normal.visible = true
		$Max.visible = false
	
	
	
	

func _process(delta: float) -> void:
	
	tp = move_toward(tp,Global.tp,10)
	$Normal/Label.text = str(tp)
	
	
	var progress_white := $Normal/ProgressWhite
	var progress_topper := $Normal/ProgressWhiteTopper
	var progress := $Normal/Progress
	
	progress_white.value = tp
	progress.value = lerp(progress.value,float(tp),delta*10.0)
	progress_topper.value = progress.value+1.0
	
