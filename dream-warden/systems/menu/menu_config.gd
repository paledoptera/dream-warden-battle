class_name MenuConfigResource extends Resource

signal open
signal close

@export var default_option: int = 0
@export var invisible_on_close: bool = true
@export var menu_sounds:= MenuSounds.new()
@export var keep_selected: bool = false
@export var keep_open: bool = false
var selected_option: int = 0
