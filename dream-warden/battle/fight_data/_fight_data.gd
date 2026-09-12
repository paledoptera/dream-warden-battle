class_name FightData extends Resource

@export var enemies: Array[CharacterStats]
@export var stage: PackedScene
@export var gimmicks: Array[String]
@export_group("Custom Party")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var custom_party: bool = false
@export var party: Array[CharacterStats]
@export var soul_bearer: StringName
