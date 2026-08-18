@abstract class_name Item extends Resource

@export var title: StringName = "Item"
@export_multiline var description: String

func use(user : AbstractFighter, used_on : AbstractFighter) -> void:
	pass#effect.do_effect(user,used_on)
