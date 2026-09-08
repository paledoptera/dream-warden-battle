class_name Grazer extends Area2D

signal can_fade_out

var graze_sprite_frame: float = 0.0: 
	set(value):
		graze_sprite_frame = value
		match value:
			0:
				$Sprite2D.visible = false
			_:
				$Sprite2D.visible = true
				$Sprite2D.frame = int(value)-1
var fade_tween: Tween
var trying_to_fade_out: bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	if trying_to_fade_out:
		if has_overlapping_areas():
			graze_sprite_frame = move_toward(graze_sprite_frame,1.0,0.5)
			print("FRAME", graze_sprite_frame)
		else:
			can_fade_out.emit()
			trying_to_fade_out = false

func _on_area_entered(area: Area2D) -> void:
	if area is not Bullet:
		return
	
	Party.tp += area.graze_points
	Sound.play(preload("res://shared/sound_effects/snd_graze.wav"))
	
	
	graze_sprite_frame = 4
	modulate = Color.WHITE
	trying_to_fade_out = false
	if fade_tween:
		fade_tween.kill()
	await get_tree().create_timer(0.166666).timeout
	if has_overlapping_areas():
		trying_to_fade_out = true
		await can_fade_out
	fade_tween = create_tween()
	fade_tween.tween_property(self,"modulate",Color("ffffff00"),0.166666)
