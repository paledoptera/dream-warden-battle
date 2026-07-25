extends Item
class_name Equippable

enum Category {
	SWORD,
	SCARF,
	AXE,
	ARMOR,
	LIGHT_ARMOR
}

@export var category : Category
@export var fighter_stat_modifiers : Dictionary[AbstractFighter.Stats, int]
@export var attributes : Dictionary[EquippableAttribute, int]
