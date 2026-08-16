class_name ActionButton extends Sprite2D

var selected: bool = false:
	set(value):
		if value:
			frame_coords.y = 1
			$ActionText.visible = true
		else:
			frame_coords.y = 0
			$ActionText.visible = false
		selected = value

func _ready() -> void:
	$ActionText.frame = frame_coords.x
