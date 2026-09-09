extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	Conductor.set_song(preload("uid://5y5wc8tatwl2"),138.979,4,0)
	Conductor.play()
	Conductor.volume_linear = 0.5
	
	$ConductedAnimationPlayer.play("clock")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
