class_name CharacterStatsEnemy extends CharacterStats

enum Order { RANDOM, SEQUENTIAL }

@export_group("Attacks")
@export var attack_order := Order.RANDOM
@export var attacks: Array[Attack]
@export_group("Dialogue")
@export var check_text : Array[DialogueString]
@export var opening_line_singular := DialogueString.new()
@export var opening_line_plural := DialogueString.new()
@export var flavor_text_order := Order.RANDOM
@export var flavor_text : Array[DialogueString]
@export var dialogue_order := Order.RANDOM
@export var dialogue : Array[DialogueBlock]
@export var mercy_fail_text: Array[DialogueString]
@export_group("Data")
@export var soundbank: Dictionary[StringName, AudioStream]
@export var next_phase: PackedScene
@export_group("Interactions")
## Attacks to this enemy will always miss
@export var unhittable: bool = false
