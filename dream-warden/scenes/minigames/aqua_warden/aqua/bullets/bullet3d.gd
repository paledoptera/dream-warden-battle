extends Area3D
class_name Bullet3D

@export_group("Stats")
@export var damage := 1
## The amount of TP gained by grazing
@export var graze_points := 5
## How much the turn timer is reduced when grazing (in seconds)
@export var time_points := 5.0 / 30.0
##Whether the pellet gets destroyed if it collides
@export var destructible: bool = false
##If the pellet can hit you even if you have i-frames
@export var ignore_iframes: bool = false
##If the bullet can be parried
@export var parryable : bool = false
@export var parry_points := 0
@export var destroy_effect: PackedScene
@export var parry_break_sfx : AudioStream

@export_group("Movement")
@export var velocity := Vector3.ZERO
@export var speed_multiplier := 1.0
@export var life_time := 2.0
@export var linear_acceleration := 0.0

var grazed := false
var time := 0.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	time += delta
	velocity += velocity * linear_acceleration * delta * speed_multiplier
	
	if time >= life_time:
		if life_time != -1.0:
			queue_free()
	global_position += velocity * delta

func _on_area_entered(area: Area3D) -> void:
	if area is AquaPlayer:
		print("PLAYER HIT")
		area.hurt(damage,ignore_iframes)
		if destructible:
			destroy()

func destroy() -> void:
	if destroy_effect:
		var particle = destroy_effect.instantiate()
		if particle is CPUParticles3D:
			particle.finished.connect(particle.queue_free)
			particle.emitting = true
		get_parent().add_child(particle)
		particle.global_position = global_position
	queue_free()
