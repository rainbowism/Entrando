extends ColorRect

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and event.is_pressed():
			Events.emit_signal("mode_changed", Util.MODE_OW)
			hide()
