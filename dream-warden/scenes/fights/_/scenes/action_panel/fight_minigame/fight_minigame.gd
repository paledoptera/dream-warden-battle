extends Node2D

@export var hitmarker: Sprite2D
var hitmarker_afterimage_timer: int = 0
var pressed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Battle.fight_scene.action_panel.action_menu.deactivate()
	create_afterimage()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if pressed:
		return
	
	if hitmarker_afterimage_timer >= 2:
		hitmarker_afterimage_timer -= 2
		create_afterimage()
	
	hitmarker_afterimage_timer += 1
	
	hitmarker.position.x -= 7.0 * Engine.time_scale

func create_afterimage() -> void:
	var inst = hitmarker.duplicate()
	add_child(inst)
	inst.global_position = hitmarker.global_position
	inst.modulate = Color("ffffff79")
	var tween = create_tween()
	tween.tween_property(inst,"modulate",Color("ffffff00"),0.3333)
	tween.tween_callback(inst.queue_free)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm") and not pressed:
		Sound.play(preload("res://shared/sound_effects/snd_laz.wav"))
		if hitmarker.position.x >= 91.0 and hitmarker.position.x <= 98.0:
			hitmarker.position.x = 91.0
		if round(hitmarker.position.x) == 91.0:
			$AnimationPlayer.play("perfect_hit")
		else:
			$AnimationPlayer.play("hit")
		pressed = true
		await get_tree().create_timer(0.6666).timeout
		Battle.goto_next_phase()
