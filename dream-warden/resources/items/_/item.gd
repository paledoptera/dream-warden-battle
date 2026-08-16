class_name Item extends Resource


enum InventoryTab{
	ITEMS,
	KEY_ITEMS,
	ARMORS,
	WEAPONS
}

@export var name := "Equippable"
@export var short_description := ""
@export_multiline var long_description := "An item that can be equipped."
@export var sell_value : int = 0
@export var inventory_tab : InventoryTab
@export var effect: ItemEffect
