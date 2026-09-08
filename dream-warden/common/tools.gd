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
