## Soul Selectable Button
extends RPGMenuButton

@export var offset: Vector2

func _on_focus_entered() -> void:
	super()
	var soul = Tools.find_child_in_group(get_owner(),"soul")
	soul.global_position = global_position + offset
