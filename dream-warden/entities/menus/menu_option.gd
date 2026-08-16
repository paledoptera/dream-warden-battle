class_name MenuOption extends Node

enum Layout {VERTICAL, HORIZONTAL}

@export_group("Neighbours")
@export var left: Node
@export var right: Node
@export var down: Node
@export var up: Node

@export var default_layout = Layout.VERTICAL

@onready var parent: Node = get_parent()
