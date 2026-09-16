class_name EnemyBulletFormula extends DamageFormula

static func calculate(value: int, attacker: CharacterStats, target: CharacterStats) -> int:
	var damage = float(value)
	damage *= attacker.attack
	damage -= (3 * target.defense)
	
	if target.defending:
		damage *= 0.66
	
	damage = ceilf(damage)
	
	return int(damage)
