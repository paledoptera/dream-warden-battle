class_name Tools

static func find_child_in_group(parent: Node, group: String, recursive: bool = false):
	var output: Node = null
	for child in parent.get_children() :
		if child.is_in_group(group) :
			return child
	if recursive :
		for child in parent.get_children() :
			output = find_child_in_group(child, group, recursive)
			if output != null :
				return output
	return output
	
static func find_children_in_group(parent: Node, group: String, recursive: bool = false):
	var output: Array[Node] = []
	for child in parent.get_children() :
		if child.is_in_group(group) :
			output.append(child)
	if recursive :
		for child in parent.get_children() :
			var recursive_output =  find_children_in_group(child, group, recursive)
			for recursive_child in recursive_output :
				output.append(recursive_child)
	return output

static func find_nearest_child_to_node(parent: Node, node: Node2D) -> Node2D:
	var closest: Node2D = null
	var closest_distance : float = INF
	var to_position: Vector2 = node.global_position
	
	for child: Node2D in parent.get_children():
		if child == node:
			continue
		var distance: float = to_position.distance_squared_to(child.global_position)
		if distance < closest_distance:
			closest = child
			closest_distance = distance
	
	return closest
