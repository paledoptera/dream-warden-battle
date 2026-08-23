extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Conductor.set_song(preload("uid://5y5wc8tatwl2"),138.979,4,0)
	Conductor.play()
	
	$ConductedAnimationPlayer.play("clock")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
