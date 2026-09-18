extends Node2D

@export var fighting = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func toggle_fight_mode():
	if fighting:
		fighting = false
		$"AnimationPlayer".play_backwards("fight_start")
	else:
		fighting = true
		$"AnimationPlayer".play("fight_start")
	pass
