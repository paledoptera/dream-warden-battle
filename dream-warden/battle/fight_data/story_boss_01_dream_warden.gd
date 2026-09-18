class_name StoryBossDreamWarden extends StoryBattleController

const WARDEN_PARRY := preload("uid://781molbb62mr")
const SUSIE_PARRY := preload("uid://cejx8k37iiy3")
var phase = 0
var cinematic_jumps = 0

func player_turn_end() -> void:
	
	var percent = (float(Party.enemy[0].hp) / float(Party.enemy[0].hp_max)) * 100.0
	
	if percent < 75.0 and cinematic_jumps == 0:
		cinematic_jumps = 1
		
		Dialogue.display_text(preload("uid://dovf0fo1gs5et"))
		await Dialogue.text_finished
		Dialogue.clear_text.emit()
		EventBus.battle_event.emit("slide_out",null)
		EventBus.actor_do_action.emit("susie", "jump_attack")
		await Global.get_tree().create_timer(3.0).timeout
		SceneLoader.change_scene(preload("uid://dbi6lj71m2qh8"))
		return
		
	
	if phase != Flags.story.dream_warden_phase:
		phase = Flags.story.dream_warden_phase
		match phase:
			0:
				pass
			1:
				_transform_enemy(Party.enemy[0],WARDEN_PARRY)
				_transform_hero(Party.hero[0],SUSIE_PARRY)
	await Party.get_tree().physics_frame
	finished.emit()
	return
	
	
