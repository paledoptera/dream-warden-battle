class_name ItemPrismShard extends ItemEffect

func do_effect(user : AbstractFighter, used_on : AbstractFighter) -> void:
	user.prism_shield = 2
