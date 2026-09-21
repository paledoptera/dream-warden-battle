extends Node2D

signal finished


var random_positions: Array[int]
var quicktimes: Dictionary[int, Node]
var active: Array[bool]
var targets: Array


func enable(array: Array):
	active = [false, false, false]
	
	var total_count: int = 0
	
	for i in array:
		if i:
			total_count += 1
	
	match total_count:
		1:
			random_positions = [0]
		2:
			random_positions = [0,randi_range(1,2)]
		3:
			random_positions = [0,randi_range(1,2),randi_range(3,4)]
	
	random_positions.shuffle()
	
	var ind = 0
	
	for i in $Fighters.get_child_count():
		var quicktime_event = $Fighters.get_child(i)
		
		quicktime_event.target = targets[i]
		
		if not array[i]:
			quicktime_event.visible = false
			continue
		
		active[ind] = true
		
		var hitmarker_pos = random_positions[ind]
		
		if quicktime_event.has_method("set_up"):
			quicktime_event.set_up(hitmarker_pos)
			quicktime_event.create_afterimage()
			quicktime_event.index = i
			quicktimes[hitmarker_pos] = quicktime_event
			finished.connect(quicktime_event.finished)
		
		ind += 1
	
	random_positions.sort()
	
	


func _process(delta: float) -> void:
	if not active:
		return
	
	var event_disabled = -1
	
	for ind in quicktimes.keys():

		var quicktime_event = quicktimes[ind]
		
		if not quicktime_event:
			continue
		
		quicktime_event.move()
		
		if not quicktime_event.check():
			print("SHIT")
			event_disabled = ind
			
	
	if event_disabled != -1:
		print("SHIT")
		quicktimes[event_disabled].active = false
		quicktimes[event_disabled].do_attack(true)
		quicktimes.erase(event_disabled)
		check_if_finished()
		print("QUICKTIMES: ", quicktimes)
		


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm"):
		press()

func press() -> void:
	if not quicktimes:
		return
	
	print(quicktimes)
	
	var pressed = quicktimes[random_positions[0]].press()
	
	if not pressed:
		return
	
	quicktimes.erase(random_positions.pop_front())
	
	check_if_finished()

func check_if_finished() -> void:
	if quicktimes:
		return
	
	await get_tree().create_timer(1.666).timeout
	EventBus.end_fight_minigame.emit()
	
	$AnimationPlayer.play("fade_out")
		
	print("ATTACK FINISHED")
	finished.emit()
