@abstract class_name SpellEffect extends Resource

var spell: Spell

@abstract func do_effect(user : AbstractFighter, used_on : AbstractFighter) -> void
