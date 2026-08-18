class_name Inventory extends Node

@export var items : Array[Item] = [
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null,
]

func use_item(index: int, user: AbstractFighter, target: AbstractFighter):
	if items.size() <= index:
		return
	
	if not items[index]:
		return
	
	
	var item: Item = items[index]
	
	print(item)
	
	if item is Consumable:
		item.use(user,target)
		items.erase(item)
	
