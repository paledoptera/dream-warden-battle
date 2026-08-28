extends Node

func change_scene(scene: PackedScene) -> Node:
	var scene_inst = scene.instantiate()
	get_tree().change_scene_to_node(scene_inst)
	return scene_inst
