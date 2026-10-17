extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	Dialogue.display_text(preload("uid://530d0u2wa5ui"))
	await Dialogue.text_finished
	Dialogue.clear_text.emit
	Battle.start(
		preload("uid://blfmq23jgwm5h") # fight_boss_00_dream_warden
	)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
