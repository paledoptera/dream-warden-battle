class_name CharacterStats extends Resource

signal hp_changed(new_hp: int)

@export var name: String = "Character"
@export var color: Color = Color.WHITE
@export_group("Stats")
@export var hp_max: int = 100
@export var hp: int = 100:
	set(value):
		hp = clampi(value,0,hp_max)
		hp_changed.emit(hp)
@export var attack: int = 1
@export var defense: int = 1
@export var magic: int = 1
@export_group("Misc")
@export var character_id: StringName = "character"
@export var status_effects: Array[StatusEffect]
@export_group("Gimmicks")
@export var on_hit_gimmick: StringName = ""
@export_group("Data")
@export var soundbank: Dictionary[StringName, AudioStream]
