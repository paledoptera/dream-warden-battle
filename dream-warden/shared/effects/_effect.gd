@abstract class_name Effect extends Resource

signal effect_applied

var target := Enums.Target.HERO

@abstract func apply(user: int, target: int) -> void
