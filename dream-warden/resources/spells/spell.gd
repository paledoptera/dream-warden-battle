class_name Spell extends Resource

@export var title: StringName
@export_multiline var description: String
@export var spell_effect: SpellEffect
@export var tp_cost: int = 32
@export var targets_own_party: bool = false

func cast(user : AbstractFighter, used_on : AbstractFighter) -> void:
	spell_effect.spell = self
	spell_effect.do_effect(user,used_on)
	EventBus.battle_tp_subtract.emit(tp_cost)
