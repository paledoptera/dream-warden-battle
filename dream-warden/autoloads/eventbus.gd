extends Node

signal battle_event(event: StringName, value: Variant)
signal heal_hero(heal_amount: int, id: int)
signal actor_do_action(id: StringName, action: StringName)
signal world_event(event: StringName)
signal play_animation(anim_name: StringName)
