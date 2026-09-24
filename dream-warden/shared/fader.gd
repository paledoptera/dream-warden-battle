extends Node

var fade_rect: ColorRect

func _ready() -> void:
	fade_rect = ColorRect.new()
	fade_rect.size = Vector2(2000.0,2000.0)
	fade_rect.global_position = Vector2(-1000.0,-1000.0)
	fade_rect.color = Color.TRANSPARENT
	fade_rect.focus_mode = Control.FOCUS_NONE
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_rect.z_index = 4096
	add_child(fade_rect)

func fade_in(length: float = 0.3, color := Color.WHITE, ease: Tween.EaseType = Tween.EASE_IN_OUT, trans: Tween.TransitionType = Tween.TRANS_LINEAR):
	fade_rect.color = Color.TRANSPARENT
	var tween = create_tween()
	tween.tween_property(fade_rect,"color",color,length).set_ease(ease).set_trans(trans)

func fade_out(length: float = 0.3, color := Color.WHITE, ease: Tween.EaseType = Tween.EASE_IN_OUT, trans: Tween.TransitionType = Tween.TRANS_LINEAR):
	fade_rect.color = color
	var tween = create_tween()
	tween.tween_property(fade_rect,"color",Color.TRANSPARENT,length).set_ease(ease).set_trans(trans)
