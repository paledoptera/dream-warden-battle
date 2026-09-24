extends Node

signal battle_event(event: StringName, value: Variant)
signal hero_attack(event_object: AttackEvent)
signal heal_hero(heal_amount: int, id: int)
signal enter_fight_minigame(characters: Array, targets: Array)
signal end_fight_minigame
signal world_event(event: StringName)
signal play_animation(anim_name: StringName)
signal damage_player(amount: int)
signal battle_ended
