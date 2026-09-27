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
var siner: float = 0.0
var start_y: float = 0.0
var freq: float = 1.0
var offset: float = 1.0
var pos_tween: Tween

func _ready() -> void:
	rot = rotation.y
	freq = randf_range(0.8,1.3)


func _process(delta: float) -> void:
	siner += delta
	$Platform.position.y = lerpf(0.0,start_y + Siner.get_sine(siner,0.02,freq),offset)

func animate(anim_name: StringName):
	$AnimationPlayer.current_animation = anim_name

func set_active():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Platform/Ring1,"position",Vector3(0.0,-0.155,0.0),0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($Platform,"scale",Vector3(1.0,1.0,1.0),0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)


func set_inactive():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Platform/Ring1,"position",Vector3(0.0,-0.45,0.0),1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($Platform,"scale",Vector3(0.5,1.0,0.5),1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)

func hopped_onto():
	if pos_tween:
		pos_tween.kill()
	
	pos_tween = create_tween()
	pos_tween.tween_property(self,"offset",0.0,0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)


func hopped_off():
	if pos_tween:
		pos_tween.kill()
	
	pos_tween = create_tween()
	pos_tween.tween_property(self,"offset",1.0,1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
