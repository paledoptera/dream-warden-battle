#class_name BattleTurnState extends RefCounted
### A utility object that keeps track of the current battle state.
#
#enum State {CHOOSE_ACTION, CHOOSE_ENEMY, CHOOSE_SPELL, CHOOSE_ITEM, CHECK_PARTY, HERO_ACTION, DIALOGUE, ATTACK_START, ATTACK_END}
#enum Action {FIGHT, MAGIC, ITEM, MERCY, DEFEND, NONE, BACK}
#
#signal state_changed(new_state: State)
#signal party_action_choice_entered(party_member: int, party_actions: Array[Action])
#
#var state : State:
	#set(value):
		#_on_state_changed(value)
		#state_changed.emit(value)
		#print("State = ",value)
		#print("Party actions = ",party_actions)
		#state = value
#var party_actions : Array[Action] = [
	#Action.NONE,
	#Action.NONE,
	#Action.NONE
#]
#var cached_tp: Array[float] = [
	#0.0,
	#0.0,
	#0.0,
#]
#var current_turn: int = 0
#
### The party member currently selecting an action.
### -1 means all party members have selected an action
#var current_party_member: int = 0 
#
#func start() -> void:
	#reset_party_actions()
	#state = State.CHOOSE_ACTION
#
#func _on_state_changed(new_state: State):
	#match new_state:
		#State.CHOOSE_ACTION:
			#current_party_member = get_current_party_member()
			#party_action_choice_entered.emit(current_party_member,party_actions)
			#
#
#
#func reset_party_actions():
	#party_actions.resize(Party.active_party.size())
	#for i in party_actions:
		#i = Action.NONE
	#current_party_member = 0
#
#
#func get_current_party_member() -> int:
	#var party_member: int = -1
	#
	#for i in range(party_actions.size()):
		#if party_actions[i] == Action.NONE or party_actions[i] == Action.BACK:
			#party_member = i
			#break
	#
	#return party_member
#
#
#func get_selected_action() -> Action:
	#return party_actions[current_party_member]
#
#
#func set_selected_action(action: Action) -> Action:
	#party_actions[current_party_member] = action
	#return action
#
#
#func goto_next_phase() -> void:
	#var selected_action = Menu.selected
	#
	#match state:
		## The hero has chosen an action (FIGHT, ACT/MAGIC, ITEM, MERCY or DEFEND)
		#State.CHOOSE_ACTION:
			#match selected_action:
				#Action.FIGHT, Action.MAGIC:
					#state = State.CHOOSE_ENEMY
					#
				#Action.DEFEND, Action.MERCY:
					#set_selected_action(Action.DEFEND)
					#state = State.CHECK_PARTY
				#
				#Action.ITEM:
					#state = State.CHOOSE_ITEM
		#
		#State.CHOOSE_SPELL, State.CHOOSE_ITEM:
			#state = State.CHECK_PARTY
		#
		#State.CHOOSE_ENEMY:
			#print("test")
			#match selected_action:
				#Action.FIGHT:
					#set_selected_action(Action.FIGHT)
					#state = State.CHECK_PARTY
				#Action.MAGIC:
					#state = State.CHOOSE_SPELL
		#
		#State.CHECK_PARTY:
			#print("PARTY MEMBERS: ", party_actions)
			#
			#if get_current_party_member() != -1:
				#state = State.CHOOSE_ACTION
			#else:
				#state = State.HERO_ACTION
		#
		#State.HERO_ACTION:
			#state = State.DIALOGUE
		#
		#State.DIALOGUE:
			#state = State.ATTACK_START
		#
		#State.ATTACK_START:
			#state = State.ATTACK_END
		#
		#State.ATTACK_END:
			#state = State.CHOOSE_ACTION
			#selected_action = Action.FIGHT
			#current_turn += 1
			#reset_party_actions()
			#current_party_member = 0
		#
#
#func goto_prev_phase() -> void:
	#
	#match state:
		#State.CHOOSE_ACTION:
			#if current_party_member > 0:
				#var val = current_party_member -1
				#print("actions: ", party_actions)
				#if party_actions[val] == Action.DEFEND:
					#EventBus.reverse_action.emit("defend")
				#Menu.selected = 0
				#current_party_member = val
				#print("actions: ", party_actions)
				#party_actions[current_party_member] = Action.NONE
				#get_current_party_member()
				#state = State.CHOOSE_ACTION
				#
			#
		#State.CHOOSE_ENEMY, State.CHOOSE_ITEM:
			#state = State.CHOOSE_ACTION
		#
		#State.CHOOSE_SPELL:
			#state = State.CHOOSE_ENEMY
