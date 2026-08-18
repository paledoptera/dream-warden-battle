class_name FightScene extends Node2D

@export var bgm: AudioStream
@export_group("Node Paths")
@export var action_panel: Node2D

func _ready() -> void:
	Global.in_battle = true
	
	Battle.fight_scene = self
	
	Battle.reset.emit()
	Battle.heroes_updated.emit($Heroes)
	Battle.enemies_updated.emit($Enemies)
	
	Battle.state_changed.connect(_on_battle_state_changed)
	Battle.attack_start.connect(_on_attack_started)
	
	if bgm:
		Music.play(bgm)
	
	_on_battle_state_changed(Battle.State.CHOOSE_ACTION,Battle.State.ATTACK_END)

func _on_attack_started() -> void:
	Battle.enemy_attacking = true
	Dialogue.clear_text.emit()
	Battle.do_attack($Attacks)


func _on_battle_state_changed(new_state: Battle.State, last_state: Battle.State):
	match new_state:
		Battle.State.HERO_ACTION:
			match Battle.selected_action:
				Battle.Action.DEFEND, Battle.Action.ITEM:
					await get_tree().physics_frame
					Battle.goto_next_phase()
		Battle.State.ATTACK_START:
			$AnimationPlayer.play("attack_fade")
		Battle.State.ATTACK_END:
			$AnimationPlayer.play_backwards("attack_fade")
