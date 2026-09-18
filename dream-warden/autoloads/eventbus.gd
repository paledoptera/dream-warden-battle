extends Node

signal battle_event(event: StringName, value: Variant)
signal hero_attack(event_object: AttackEvent)
signal heal_hero(heal_amount: int, id: int)
signal enter_fight_minigame(characters: Array, targets: Array)
signal end_fight_minigame
signal actor_do_action(id: StringName, action: StringName)
signal actor_set_target(id: StringName, target_id: StringName)
signal world_event(event: StringName)
signal play_animation(anim_name: StringName)
signal actor_trigger_damage_number(id: StringName, floating_text: FloatingText)
signal actor_trigger_effect(id: StringName, effect: PackedScene)
signal damage_player(amount: int)
signal battle_ended
