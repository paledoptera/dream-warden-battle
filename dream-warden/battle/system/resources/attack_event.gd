class_name AttackEvent extends Resource

@export_group("Identification")
@export var attacker: CharacterStats
@export var target: CharacterStats
@export_group("Attack Data")
@export var damage: int = 0
@export var damage_formula: DamageFormula = DamageFormula.new()

func get_damage() -> int:
	return damage_formula.calculate(damage,attacker,target)
