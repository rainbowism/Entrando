extends TextureRect

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_RIGHT \
		and event.is_pressed():
		get_tree().call_group("item", "queue_free")
