extends Area2D
class_name EndAttackArea


func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body is Soul:
		Battle.attack_area_end.emit()
