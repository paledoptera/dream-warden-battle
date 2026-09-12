class_name BattleGimmickHandler extends Node

const DARK_TP_BAR = preload("uid://btn1vhu2dcufw")

func initialize_gimmicks(gimmick_list: Array[String]):
	for gimmick in gimmick_list:
		match gimmick:
			"darkness":
				var tp_bar = get_tree().get_first_node_in_group("tp_bar")
				var dark_tp_bar = DARK_TP_BAR.instantiate()
				tp_bar.get_parent().add_child(dark_tp_bar)
				tp_bar.queue_free()
				
				Flags.battle.defend_tp = 8
				Flags.battle.attack_tp = 16

			"_":
				continue
