class_name RudeBusterFormula extends DamageFormula

static func calculate(value: int, attacker: CharacterStats, target: CharacterStats) -> int:
	
	var attack = float(attacker.attack)
	var magic = float(attacker.magic)
	
	var damage = (attack * 11) + (5 * magic) - (3 * target.defense)
	return damage
