class_name BattleBox
extends PanelContainer

var walls: Array[CollisionShape2D]

func _ready() -> void:
	var staticbody = StaticBody2D.new()
	add_child(staticbody)
	
	for i in range(4):
		var collision_shape = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		collision_shape.shape = shape
		staticbody.add_child(collision_shape)
		walls.append(collision_shape)
	
	update_collision()
	
	resized.connect(update_collision)
	
func update_collision() -> void:
	
	var sizes = [
		Vector2(8.0,size.y),
		Vector2(8.0,size.y),
		Vector2(size.x,8.0),
		Vector2(size.x,8.0)
	]
	
	var positions = [
		Vector2(0.0,size.y/2),
		Vector2(size.x,size.y/2),
		Vector2(size.x/2,0.0),
		Vector2(size.x/2,size.y)
	]
	
	for i in range(4):
		walls[i].shape.size = sizes[i]
		walls[i].position = positions[i]
