class_name CharacterStatsHero extends CharacterStats

@export_group("Equipment")
@export var weapon: ItemEquippable
@export var armors: Array[ItemEquippable]
@export_group("Spells")
@export var spells: Array[Spell]
var downed: bool = false
