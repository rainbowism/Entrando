extends Sprite

func save_data() -> Array:
	var children = []
	for child in get_children():
		if !child.visible:
			continue
		children.append({
			"is_item": child.is_item,
			"x": child.position.x,
			"y": child.position.y
		})
	return children

func load_data(children: Array) -> void:
	for node in get_children():
		node.queue_free()
	var icon_scene: PackedScene = load("res://src/Objects/Icon.tscn")
	for data in children:
		var node = icon_scene.instance()
		node.is_item = data.is_item
		add_child(node)
		node.position = Vector2(data.x, data.y)
