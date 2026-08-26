extends Node

enum State {CHOOSE_ACTION, CHOOSE_ENEMY, CHOOSE_SPELL, CHOOSE_ITEM, HERO_ACTION, DIALOGUE, ATTACK_START, ATTACK_END}
enum Action {FIGHT, MAGIC, ITEM, MERCY, DEFEND}


var state := State.CHOOSE_ACTION:
	set(value):
		state_changed.emit(value,state)
		state = value

var selected_action: Action = Action.FIGHT

var heroes: Array
var enemies: Array
var fight_scene: FightScene
var target: int = 0

var soul_speed: float = 120.0
var attack_scene: Node

var turn: int = 0

var soul: Soul


var enemy_attacking: bool = false:
	set(value):
		var last = enemy_attacking
		enemy_attacking = value
		if last != enemy_attacking:
			if value:
				attack_start.emit()
			else:
				attack_end.emit()
				

var tp: float = 0.0:
	set(value):
		tp = value
		tp = clampf(tp,0.0,100.0)
		tp_changed.emit(tp)

signal reset
signal heroes_updated(parent_node: Node)
signal enemies_updated(parent_node: Node)
signal tp_changed(tp: float)
signal attack_start
signal attack_area_end
signal attack_end
signal state_changed(new_state: State, last_state: State)


func _ready() -> void:
	heroes_updated.connect(update_heroes)
	enemies_updated.connect(update_enemies)
	state_changed.connect(_on_state_changed)
	
	Menu.set_cursor_sprite(preload("uid://wy7dhu8gvr8c"))
	await get_tree().process_frame
	
	state_changed.emit(state,State.ATTACK_END)
	


func update_heroes(parent_node: Node):
	heroes.clear()
	heroes = parent_node.get_children()
	
	for i in fight_scene.action_panel.actions.get_children():
		if i is not ActionMenu:
			continue
		i.hero = Battle.heroes[0]
		i.update_hp_values()
		i.hero.hp_changed.connect(i._on_hp_changed)
	print(heroes)

func update_enemies(parent_node: Node):
	enemies.clear()
	enemies = parent_node.get_children()

func do_attack(parent_node: Node) -> void:
	var attack = enemies[0].get_attack()
	
	if attack.scene:
		if attack_scene:
			attack_scene.queue_free()
		attack_scene = attack.scene.instantiate()
		
		parent_node.add_child(attack_scene)
		await animate_soul_transition(attack_scene,false)
		
		if attack.length:
			await get_tree().create_timer(attack.length).timeout
		else:
			await attack_area_end
		
		finish_attack(attack_scene)
	return

func finish_attack(attack_scene: Node) -> void:
	await animate_soul_transition(attack_scene,true)
	goto_next_phase()
	
func animate_soul_transition(attack_scene: Node, end: bool = false) -> void:
	
	if not end:
		attack_scene.visible = false
		attack_scene.process_mode = ProcessMode.PROCESS_MODE_DISABLED
	else:
		attack_scene.call_deferred("queue_free")
		
	var soul_transition = preload("uid://mmposqk66pey").instantiate()
	var anim = "in"
	var time = 0.6
	heroes[0].add_child(soul_transition)
	soul_transition.start_point = heroes[0].global_position
	if get_tree().get_first_node_in_group("soul"):
		soul_transition.end_point = get_tree().get_first_node_in_group("soul").global_position
	if get_tree().get_first_node_in_group("battlebox"):
		soul_transition.battlebox.size = get_tree().get_first_node_in_group("battlebox").size
		soul_transition.battlebox_pivot.global_position = get_tree().get_first_node_in_group("battlebox").global_position
	
	if end:
		soul_transition.start_point = soul_transition.end_point
		soul_transition.end_point = heroes[0].global_position
		anim = "out"
		time = 0.4
		
	soul_transition.anim.play(anim)
	await get_tree().physics_frame
	await get_tree().create_timer(time).timeout
	
	
	
	if not end:
		attack_scene.visible = true
		attack_scene.process_mode = ProcessMode.PROCESS_MODE_INHERIT
		soul_transition.queue_free()
	else:
		soul_transition.destroy()

func get_opening_line() -> DialogueString:
	var dialogue = enemies[0].get_opening_line()
	return dialogue
	
	## below is unused for now (will be used if there's multiple enemies)
	
	#for enemy: Enemy in enemies:
		#if enemy == enemies[0]
			#continue
		#
		#if dialogue.text != "":
			#dialogue.text += monster.get_opening_line().text
	#
	#if dialogue.text == "":
		#if Global.monsters.size() == 1:
			#dialogue.text = "  * You encountered a monster!"
		#else:
			#dialogue.text = "  * You encountered some monsters!"
	#
	#return dialogue

func get_dialogue() -> DialogueBlock:
	var dialogue = enemies[0].get_dialogue()
	return dialogue

func get_flavor_text() -> DialogueString:
	var dialogue = enemies[0].get_flavor_text()
	return dialogue

func damage_hero(value: float):
	Sound.play(preload("res://shared/sound_effects/snd_hurt1.wav"))
	
	if not heroes:
		return
	
	var hero: Hero = heroes.pick_random()
	if hero.prism_shield > 0:
		hero.prism_shield -= 1
		hero.create_floating_text_string("BLOCKED", Color("00ffff"))
		return
	
	var damage: int = (value * 5) - (hero.defense * 3)
	
	if Global.hard_mode:
		damage *= 2
	
	if hero.is_defending:
		damage *= 0.666
	
	hero.hp  -= damage
	print(damage)
	
	hero.create_floating_text_string(str(damage))


func damage_enemy(value: float, id: int = 0):
	if not enemies:
		return
	
	id = clampi(id,0,enemies.size()-1)
	var enemy: Enemy = enemies[id]
	var damage: int = value - (enemy.defense * 3)
	
	enemy.hp  -= damage
	print(damage)
	
	enemy.create_floating_text_string(str(damage))

func heal_hero(value: float, id: int = 0):
	Sound.play(preload("res://shared/sound_effects/snd_heal_c.wav"))
	
	if not heroes:
		return
	
	id = clampi(id,0,heroes.size()-1)
	var hero: Hero = heroes[id]
	
	hero.hp += value
	hero.create_floating_text_string(str(int(value)),Color.GREEN)

func goto_next_phase() -> void:
	match state:
		State.CHOOSE_ACTION:
			match selected_action:
				Action.FIGHT, Action.MAGIC:
					state = State.CHOOSE_ENEMY
				Action.DEFEND, Action.MERCY:
					state = State.HERO_ACTION
				Action.ITEM:
					state = State.CHOOSE_ITEM
		
		State.CHOOSE_SPELL, State.CHOOSE_ITEM:
			state = State.HERO_ACTION
		
		State.CHOOSE_ENEMY:
			match selected_action:
				Action.FIGHT:
					state = State.HERO_ACTION
				Action.MAGIC:
					state = State.CHOOSE_SPELL
		
		State.HERO_ACTION:
			state = State.DIALOGUE
		
		State.DIALOGUE:
			state = State.ATTACK_START
		
		State.ATTACK_START:
			state = State.ATTACK_END
		
		State.ATTACK_END:
			state = State.CHOOSE_ACTION
			selected_action = Action.FIGHT
		

func goto_prev_phase() -> void:
	
	match state:
		State.CHOOSE_ENEMY, State.CHOOSE_ITEM:
			state = State.CHOOSE_ACTION
		
		State.CHOOSE_SPELL:
			state = State.CHOOSE_ENEMY

func _on_state_changed(new_state: State, last_state: State) -> void:
	match new_state:
		State.ATTACK_START:
			enemy_attacking = true
		
		State.ATTACK_END:
			enemy_attacking = false
			await get_tree().create_timer(0.2).timeout
			turn += 1
			goto_next_phase()

func get_target_enemy() -> Enemy:
	target = clampi(target,0,enemies.size()-1)
	return enemies[target]

func try_mercy() -> void:
	if enemies[0].try_mercy():
		pass
	else:
		Dialogue.display_text(enemies[0].mercy_fail_text)
		await Dialogue.text_finished
		goto_next_phase()
	
