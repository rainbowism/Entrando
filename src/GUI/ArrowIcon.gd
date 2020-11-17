extends TextureRect

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.is_pressed() \
		and event.button_index == BUTTON_RIGHT:
			queue_free()
