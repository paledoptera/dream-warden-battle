extends MeshInstance3D

@export var speed: float = 1.0


func _ready() -> void:
	rotation.y = randf()
	speed *= randf_range(0.5,1.5)
	speed *= [-1,1].pick_random()

func _process(delta: float) -> void:
	rotate_y(speed*delta)
