class_name OrangeAttack extends Node2D

@export var soul: SoulOrange
var orange_track

func _ready() -> void:
	orange_track = get_tree().get_first_node_in_group("orange_track")

func _process(delta: float) -> void:
	var speed = soul.orange_velocity
	$TrackBullets.global_position += speed * delta
	orange_track.scroll_offset += speed * delta
