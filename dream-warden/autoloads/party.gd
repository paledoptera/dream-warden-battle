extends Node

var active_party: Array[CharacterStats] = []

func add_party_member(character: CharacterStats) -> void:
	active_party.append(character)
