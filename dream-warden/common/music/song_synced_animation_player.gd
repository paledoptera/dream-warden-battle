class_name SongSyncedAnimationPlayer extends AnimationPlayer

func _ready() -> void:
	speed_scale = 0.0

func _process(delta: float) -> void:
	seek(Music.current_position,true)
