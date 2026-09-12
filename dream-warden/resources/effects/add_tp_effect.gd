class_name AddTPEffect extends Effect

@export var amount: float = 20.0

func apply(_user: int, _target: int) -> void:
	Party.tp += amount
	effect_applied.emit()
