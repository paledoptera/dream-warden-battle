class_name TPBar extends Node2D

var tp: int = 0
var tp_display: int = 0

func _update_tp(value: float) -> void:
	tp = clampi(value,0,100)
	
	if tp == 100:
		$Normal.visible = false
		$Max.visible = true
	else:
		$Normal.visible = true
		$Max.visible = false

func _ready() -> void:
	Party.tp_changed.connect(_update_tp)

func _process(delta: float) -> void:
	tp_display = move_toward(tp_display,tp,10)
	$Normal/Label.text = str(tp_display)
	
	var progress_white := $Normal/ProgressWhite
	var progress_topper := $Normal/ProgressWhiteTopper
	var progress := $Normal/Progress
	
	progress_white.value = tp_display
	progress.value = lerp(progress.value,float(tp_display),delta*10.0)
	progress_topper.value = progress.value+1.0
	
