class_name Enemy extends AbstractFighter

enum Order { RANDOM, SEQUENTIAL }

@export_group("Attacks")
@export var attack_order := Order.RANDOM
@export var attacks: Array[Attack]
@export_group("Dialogue")
@export var opening_line_singular := DialogueString.new()
@export var opening_line_plural := DialogueString.new()
@export var flavor_text_order := Order.RANDOM
@export var flavor_text : Array[DialogueString]
@export_group("Data")
@export var soundbank: Dictionary[StringName, AudioStream]
@export var next_phase: PackedScene

var turn = 0
var repetitions = 0

func _ready() -> void:
	super()
	Battle.attack_end.connect(progress_turn)

func progress_turn() -> void:
	turn += 1
	check_phase()

func get_opening_line() -> DialogueString:
	for enemy: Enemy in Battle.enemies:
		if enemy == null or enemy == self:
			continue
		return opening_line_plural
	return opening_line_singular

func get_attack() -> Attack:
	var attack_turn = wrapi(turn,0,attacks.size())
	
	if attack_turn < turn:
		repetitions = floor(float(turn) / float(attacks.size()))
		print("REPITITIONS: ", repetitions)
	
	match attack_order:
		Order.SEQUENTIAL:
			pass
			
		Order.RANDOM:
			attacks.shuffle()
	

	if attacks[attack_turn]:
		return attacks[attack_turn]
	else:
		return Attack.new()

func get_flavor_text() -> DialogueString:
	var dialogue_turn = wrapi(turn,0,flavor_text.size())
	
	match flavor_text_order:
		Order.SEQUENTIAL:
			pass
			
		Order.RANDOM:
			flavor_text.shuffle()
	
	if flavor_text[dialogue_turn]:
		return flavor_text[dialogue_turn]
	else:
		return DialogueString.new()

func check_phase() -> void:
	## put a conditional to goto_next_phase here if you want a multi-phase enemy/boss
	pass

func goto_next_phase() -> void:
	var new_phase = next_phase.instantiate()
	new_phase.hp = hp
	get_parent().add_child(new_phase)
	new_phase.global_position = global_position
	var enemies_root = get_parent()
	reparent(get_tree().root)
	Battle.update_enemies(enemies_root)
	queue_free()
	
