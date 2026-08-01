extends Node3D
class_name AquaCircle

@export var right: AquaCircle
@export var right_dist: float = 60.0
@export var left: AquaCircle
@export var left_dist: float = 60.0
@export var up: AquaCircle
@export var down: AquaCircle

static var default_color = Color("000073")
static var unselected_color = Color("006dff")
static var selected_color = Color("00ffff")

@onready var sprite = $SpriteContainer/Sprite3D

var rot: float = 0.0

func _ready() -> void:
	rot = rotation.y
