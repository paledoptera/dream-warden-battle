extends Node

enum Order { RANDOM, SEQUENTIAL }
enum GameState { SCREEN, OVERWORLD, CUTSCENE, BATTLE }

signal game_restarted


var game_state: GameState = GameState.SCREEN

var reset_timer: float = 0.0

func _process(delta: float) -> void:
	if Input.is_action_pressed("restart_game"):
		reset_timer += delta
	else:
		reset_timer = 0.0
	
	if reset_timer >= 1.0:
		reset_timer = 0.0
		game_restarted.emit()
	
