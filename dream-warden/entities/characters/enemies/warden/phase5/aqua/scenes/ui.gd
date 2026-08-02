extends Node2D

signal active_changed(value: bool)
signal action_done(value: int)

var scale_effect: float = 1.0
var tp: int = 0
var allow_input: bool = false
var active: bool = false:
	set(value):
		active = value
		active_changed.emit(value)
		if active:
			await get_tree().create_timer(0.1).timeout
			active = true
			for i in $Active/Actions.get_children():
				i.frame_coords.y = 0
			$Active/Titles.visible = false
			$Normal.visible = false
			$Active.visible = true
			Engine.time_scale = 0.05
			
			await get_tree().create_timer(0.02).timeout
			allow_input = true
			selected = 1
			$Active/Titles.visible = true
			await get_tree().create_timer(0.04).timeout
			if active:
				draining_tp = true
		else:
			draining_tp = false
			allow_input = false
			Engine.time_scale = 1.0
			$Normal.visible = true
			$Active.visible = false
var draining_tp: bool = false
@onready var start_pos := global_position
var selected: int = 1:
	set(value):
		value = wrapi(value,0,3)
		var action_icons = $Active/Actions.get_children()
		var action_titles = $Active/Titles.get_children()
		
		action_icons[selected].frame_coords.y = 0
		action_titles[selected].visible = false
		action_icons[value].frame_coords.y = 1
		action_titles[value].visible = true
		selected = value


func _ready() -> void:
	Battle.tp_changed.connect(_update_tp)
	

func _update_tp(value: float) -> void:
	if not active:
		scale_effect += (value - tp)/50
	if value < 100.0 and not draining_tp:
		active = false
	elif value == 100.0:
		active = true
		$Active/TP.value = 99.0
		$Active/TP/TPNum.text = str(int(99.0))


func _process(delta: float) -> void:
	tp = lerp(tp,int(Battle.tp),0.33)
	
	if active:
		active_anim()
		select_process()
		scale = Vector2.ONE
		scale_effect = 1.0
	else:
		inactive_anim()
		progress_anim(delta)
		scale = Vector2.ONE * scale_effect
	

func select_process() -> void:
	if draining_tp:
		Battle.tp -= 0.5
		$Active/TP.value = Battle.tp
		$Active/TP/TPNum.text = str(int(Battle.tp))
		Battle.tp = max(Battle.tp,0.0)
		if Battle.tp == 0:
			draining_tp = false
			active = false

func action() -> void:
	action_done.emit(selected)
	match selected:
		0:
			Battle.heal_hero(150.0)
			Battle.tp = 0.0
			active = false
		1:
			Sound.play(preload("uid://b1b6o1bp1u6f1"))
			Battle.tp = 0.0
			active = false
			await get_tree().create_timer(0.3).timeout
			Battle.damage_enemy(150.0)
			Sound.play(preload("uid://dvuvxfskkh7fn"))
			Sound.play(Battle.enemies[0].soundbank["damage"])
			
			
		2:
			pass
	scale_effect = 1.0
	pass


func inactive_anim() -> void:
	scale_effect = lerpf(scale_effect,1.0,0.4)
	global_position = lerp(global_position,start_pos,0.2)

func active_anim() -> void:
	global_position = lerp(global_position,start_pos+Vector2(0.0,-60.0),0.2)
	scale_effect = 1.0

func progress_anim(delta: float) -> void:
	var progress_white := $Normal/ProgressWhite
	var progress_topper := $Normal/ProgressWhiteTopper
	var progress := $Normal/Progress
	
	progress_white.value = tp
	progress.value = lerp(progress.value,float(tp),delta*4.0)
	progress_topper.value = progress.value+2.5

func _unhandled_input(event: InputEvent) -> void:
	if not active or not allow_input:
		return
	
	if not event.is_action("up") and not event.is_action("down") and not event.is_action("confirm"):
		return
		
	print(event)
	print("SELECTED: ", selected)
	
	var last_selected = selected
	
	if event.is_action_pressed("up"):
		selected -= 1
	elif event.is_action_pressed("down"):
		selected += 1
	
	if last_selected != selected:
		Sound.play(preload("uid://con5cuooujhtc"))

	if event.is_action_pressed("confirm"):
		Sound.play(preload("uid://dhgp6ob58xc1m")) # snd_select.wav
		action()
