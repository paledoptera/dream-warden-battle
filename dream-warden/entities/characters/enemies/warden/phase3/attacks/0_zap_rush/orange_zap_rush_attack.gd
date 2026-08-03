extends OrangeAttack

var valid_markers: Array[Node2D]
var count: int = 0

func _on_timer_timeout() -> void:
	
	if valid_markers.size() < 2:
		return
	var bullet = preload("uid://ds6qyt7d0yshl").instantiate()
	var current_valid = valid_markers.duplicate()
	current_valid.shuffle()
	bullet.start_pos = current_valid.pop_front()
	bullet.end_pos = current_valid.pick_random()
	$Battlebox.add_child(bullet)
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Bullet:
		valid_markers.append(area)
		
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is Bullet:
		valid_markers.erase(area)
