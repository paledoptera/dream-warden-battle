extends Node2D


func _ready() -> void:
	Music.beat.connect(_on_beat)


func _on_beat() -> void:
	$Sprite2D.rotate(deg_to_rad(4.5))
	Sound.play(preload("uid://dqdqlcl363j8h"),0.7)
