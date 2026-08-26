extends FightScene

@export var warden: Enemy

func _ready() -> void:
	super()
	Events.world_event.connect(_on_world_event)

func _on_world_event(event: StringName) -> void:
	match event:
		"enter_parry_mode":
			var parent = tp_bar.get_parent()
			var pos = tp_bar.global_position
			tp_bar.queue_free()
			tp_bar = preload("uid://b5qm5rv6tx8lt").instantiate()
			parent.add_child(tp_bar)
			tp_bar.global_position = pos
			
			warden = warden.transform_into(preload("uid://4arqgvofsxsd"))
			
		"exit_parry_mode":
			
			var parent = tp_bar.get_parent()
			var pos = tp_bar.global_position
			tp_bar.queue_free()
			tp_bar = preload("uid://jhaejpx46ycp").instantiate()
			parent.add_child(tp_bar)
			tp_bar.global_position = pos
			
			warden = warden.transform_into(preload("uid://cs6cms21rjeis"))
