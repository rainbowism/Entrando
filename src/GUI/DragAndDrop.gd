extends TextureRect

var translucent: Color = Color8(255, 255, 255, 60)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and event.is_pressed():
		Util.drag_and_drop = !Util.drag_and_drop
		if Util.drag_and_drop:
			modulate = Color.white
		else:
			modulate = translucent
