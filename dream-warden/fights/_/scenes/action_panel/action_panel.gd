class_name ActionPanel extends Node2D

enum Action {FIGHT, MAGIC, ITEM, MERCY, DEFEND}

var selected_action: Action = Action.FIGHT
@export var actions: Node2D
@export var action_menu: ActionMenu
@onready var current_menu: Node = $Actions/ActionMenu


func slide_down() -> Tween:
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(position.x,481.0),0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	return tween


func hide_health() -> void:
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(0.0,520.0),0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func spawn_menu(menu: PackedScene) -> void:
	if current_menu:
		if current_menu is not ActionMenu:
			current_menu.queue_free()
	$DialogueBox.visible = false
	var inst = menu.instantiate()
	add_child(inst)
	current_menu = inst
	if inst.has_signal("spawn_menu"):
		inst.spawn_menu.connect(spawn_menu)


func _on_selected_action_changed(new_action: int) -> void:
	selected_action = new_action as Action


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("cancel"):
		reset_action_menu()

			

func reset_action_menu() -> void:
	if current_menu is not ActionMenu:
		current_menu.queue_free()
		current_menu = $Actions/ActionMenu
		current_menu.unfreeze()
		$DialogueBox.visible = true
