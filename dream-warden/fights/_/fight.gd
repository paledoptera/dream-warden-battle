extends Node2D

@export var bgm: AudioStream

func _ready() -> void:
	Battle.reset.emit()
	Battle.heroes_updated.emit($Heroes)
	Battle.enemies_updated.emit($Enemies)
	
	if bgm:
		Music.play(bgm)
	
	Dialogue.display_text.emit(Battle.get_opening_line())
	
	

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("up"):
		Battle.tp += 20
	if Input.is_action_just_pressed("down"):
		Battle.tp -= 20
	
	if Input.is_action_just_pressed("confirm"):
		Sound.play(preload("uid://ddhxsdl3aap7i"))
