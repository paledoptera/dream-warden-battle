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
var turn = 0
var repetitions = 0

func _ready() -> void:
	Battle.attack_end.connect(progress_turn)

func progress_turn() -> void:
	turn += 1

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
