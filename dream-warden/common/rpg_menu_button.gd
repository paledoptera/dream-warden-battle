class_name RPGMenuButton extends Control

signal selected(index: int)
signal blocked

@export var disabled: bool = false
var menu_sounds:= MenuSounds.new()
var menu: MenuConfigResource


func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)

func _on_focus_entered() -> void:
	Sound.play(menu_sounds.move)
	menu.selected_option = get_index()


func _on_focus_exited() -> void:
	pass

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm"):
		if disabled:
			blocked.emit()
			return
		
		selected.emit(get_index())
		print(self, " = selected")
		Sound.play(menu_sounds.select)
