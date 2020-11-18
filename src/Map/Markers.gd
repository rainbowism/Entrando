extends Node2D

func save_data() -> Array:
	var children = []
	for child in get_children():
		if !child.visible:
			continue
		children.append({
			"sprite_path": child.sprite_path,
			"connector": child.connector,
			"is_connector": child.is_connector,
			"x": child.position.x,
			"y": child.position.y
		})
	return children

func load_data(children: Array) -> void:
	for node in get_children():
		node.queue_free()
	var marker_scene: PackedScene = load("res://src/Objects/Marker.tscn")
	for data in children:
		var node = marker_scene.instance()
		node.sprite_path = data.sprite_path
		node.connector = data.connector
		node.is_connector = data.is_connector
		add_child(node)
		node.position = Vector2(data.x, data.y)
