@abstract class_name Usable extends Resource

signal finished

@export var name: StringName = "Usable"
@export_multiline var description: String
@export var effects: Array[Effect]
@export var target := Enums.Target.HERO
## The delay in seconds before the effect is cast (if you want to make the effect happen with an animation)
@export var delay : float = 0.0
@export var use_text := DialogueString.new("* %s used %s!")

func use(user: int, target: int) -> void:
	for i in effects:
		if i.target != target:
			i.target = target
		i.apply(user,target)
		await i.effect_applied
		print("EFFECT APPLIED")
		continue
	await Party.get_tree().physics_frame
	print("FINISHED")
	finished.emit()
