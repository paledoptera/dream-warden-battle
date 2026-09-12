class_name CharacterStatsEnemy extends CharacterStats

enum Order { RANDOM, SEQUENTIAL }

@export_group("Attacks")
@export var attack_list: AttackList
@export_group("Dialogue")
@export var check_text : DialogueBlock
@export var opening_line_singular := DialogueString.new()
@export var opening_line_plural := DialogueString.new()
@export var flavor_text_order := Order.RANDOM
@export var flavor_text: DialogueBlock
@export var dialogue_order := Order.RANDOM
@export var dialogue : Array[DialogueBlock]
@export var mercy_fail_text: DialogueBlock
@export_group("Interactions")
## Attacks to this enemy will always miss
@export var unhittable: bool = false
@export var spareable: bool = false
