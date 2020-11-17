extends TextureRect

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and event.is_pressed():
		owner.open_menu()
