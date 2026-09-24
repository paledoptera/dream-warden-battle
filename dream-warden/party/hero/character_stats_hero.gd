class_name CharacterStatsHero extends CharacterStats

@export_group("Equipment")
@export var weapon: ItemEquippable
@export var armors: Array[ItemEquippable]
@export_group("Spells")
@export var spells: Array[Spell]
@export_group("Visuals")
@export var icons: Texture2D
@export var ui_name_scale:= Vector2(1.0,1.0)
@export var attack_effect: PackedScene
var downed: bool = false
var defending: bool = false
