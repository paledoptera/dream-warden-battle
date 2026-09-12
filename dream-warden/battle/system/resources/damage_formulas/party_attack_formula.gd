class_name PartyAttackFormula extends DamageFormula

static func calculate(value: int, attacker: CharacterStats, target: CharacterStats) -> int:
	var accuracy = float(value)
	var attack = float(attacker.attack)
	
	var damage = ((attack * accuracy)/20) - (target.defense*3)
	
	return damage
