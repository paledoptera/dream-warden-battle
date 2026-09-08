class_name AttackList extends Resource

enum Order { RANDOM, SEQUENTIAL }

@export var attack_order := Order.RANDOM
@export var attacks: Array[AttackData]
