class_name StoryBossDreamWarden extends StoryBattleController

const WARDEN_PARRY := preload("uid://781molbb62mr")
const SUSIE_PARRY := preload("uid://cejx8k37iiy3")
var phase = 0

func player_turn_end() -> void:
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
