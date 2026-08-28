extends Node

signal battle_goto_next_phase
signal battle_goto_prev_phase
signal reverse_action(action: StringName)
signal battle_flag_update(flag: StringName, value: Variant)
signal battle_tp_add(tp: float)
signal battle_tp_subtract(tp: float)
signal heal_hero(heal_amount: int, id: int)
signal character_does_action(action: StringName)
signal world_event(event: StringName)
signal play_animation(anim_name: StringName)
