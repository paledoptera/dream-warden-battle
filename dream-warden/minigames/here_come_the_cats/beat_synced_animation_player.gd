class_name BeatSyncedAnimationPlayer extends AnimationPlayer

var beat = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed_scale = 0.0
	Music.beat.connect(_on_beat)

func _process(delta: float) -> void:
	var progress = Music.beat_progress
	seek(progress+beat,true)
	print("MMUSIC PROGRESS: ", progress+beat)

func _on_beat() -> void:
	beat += 1.0
