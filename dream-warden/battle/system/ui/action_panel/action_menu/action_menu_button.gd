## ActionMenuButton
extends RPGMenuButton

func _on_focus_entered() -> void:
	super()
	
	$Sprite2D.frame_coords.y = 1

func _on_focus_exited() -> void:
	super()
	$Sprite2D.frame_coords.y = 0
