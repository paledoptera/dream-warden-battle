class_name Enemy extends AbstractFighter

@export_group("Dialogue")
@export var opening_line_singular := DialogueString.new()
@export var opening_line_plural := DialogueString.new()



func get_opening_line() -> DialogueString:
	for enemy: Enemy in Battle.enemies:
		if enemy == null or enemy == self:
			continue
		return opening_line_plural
	return opening_line_singular
