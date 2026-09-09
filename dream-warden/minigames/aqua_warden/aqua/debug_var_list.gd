class_name DebugVarList
extends RichTextLabel

@export var node : Node
@export var properties: Array[StringName]
var validated_properties: Array[StringName]

func _ready() -> void:
	if not node:
		node = get_parent()
	
	for property in properties:
		if property in node:
			print("FOUND PROPERTY", property)
			validated_properties.append(property)
	
	fit_content = true
	autowrap_mode = TextServer.AUTOWRAP_OFF

func _process(_delta: float) -> void:
	text = ""
	for i in validated_properties:
		text += str(i," = ", node.get(i),"\n")
