extends Node2D
#
#var hero: Hero
#var prism_shield: int = -1
#@export var col: Color
#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#await get_tree().physics_frame
	#
	##hero = Battle.heroes[0]
	##hero.prism_shield_changed.connect(_on_prism_shield_changed)
	##_on_prism_shield_changed(0)
#
#func _on_prism_shield_changed(value: int):
	#if prism_shield == value:
		#return
	#
	#if value > 0:
		#visible = true
	#else:
		#visible = false
	#
	#match value:
		#0:
			#$Sheild1.hide()
			#$Sheild2.hide()
		#1:
			#$Sheild1.show()
			#$Sheild2.hide()
		#2:
			#$Sheild1.show()
			#$Sheild2.show()
			#
	#prism_shield = value
