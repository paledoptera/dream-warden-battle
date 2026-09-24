class_name AttackData3D extends Resource

enum Layer { PLAYER, BOSS}

@export var scene: PackedScene
@export var length: float = 8.0 ## Length of the attack in seconds
@export var layer:= Layer.BOSS
@export var boss_stops_following: bool = false
