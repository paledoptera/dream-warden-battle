class_name FightScene extends Node2D

@export var bgm: AudioStream
@export_group("Node Paths")
@export var action_panel: Node2D

func _ready() -> void:
	Battle.fight_scene = self
	
	Battle.reset.emit()
	Battle.heroes_updated.emit($Heroes)
	Battle.enemies_updated.emit($Enemies)
	
	Battle.state_changed.connect(_on_battle_state_changed)
	Battle.attack_start.connect(_on_attack_started)
	
	if bgm:
		Music.play(bgm)
	
	Dialogue.display_text.emit(Battle.get_opening_line())


func _on_attack_started() -> void:
	Battle.enemy_attacking = true
	Dialogue.clear_text.emit()
	Battle.do_attack($Attacks)


func _on_battle_state_changed(new_state: Battle.State, last_state: Battle.State):
	match new_state:
		Battle.State.CHOOSE_ACTION:
			Dialogue.display_text.emit(Battle.get_flavor_text())
		Battle.State.ATTACK_START:
			$AnimationPlayer.play("attack_fade")
		Battle.State.ATTACK_END:
			$AnimationPlayer.play_backwards("attack_fade")
