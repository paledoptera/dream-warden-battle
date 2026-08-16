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
@export var attributes : Dictionary[EquippableAttribute, int]
