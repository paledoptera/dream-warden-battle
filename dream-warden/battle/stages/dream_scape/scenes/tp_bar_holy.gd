extends TPBar

func _process(delta: float) -> void:
	Party.tp -= 0.1
	Party.tp = clampf(Party.tp,1.0,100.0)
	#
	#if Battle.state != Battle.State.ATTACK_END:
		#Battle.tp = max(Battle.tp,1.0)
	#elif Battle.tp <= 1.0:
		#Events.world_event.emit("exit_parry_mode")
	
	super(delta)
