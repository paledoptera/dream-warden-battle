class_name HeroBattler extends Resource

enum Action {FIGHT, MAGIC, ITEM, MERCY, DEFEND}

@export var action := Action.FIGHT
@export var target := 0
@export var option := 0
@export var preparing := false 
@export var finished := false
