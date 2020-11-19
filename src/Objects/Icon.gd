tool
extends Area2D

export var is_item: bool

func _ready() -> void:
	if Engine.editor_hint:
		return

	if is_item:
		$Entrance.queue_free()
		add_to_group(Util.GROUP_ITEMS)
		$Entrance.hide()
		$Item.show()
	else:
		$Item.queue_free()
		add_to_group(Util.GROUP_ENTRANCES)
		$Entrance.show()
		$Item.hide()

func _draw() -> void:
	if Engine.editor_hint:
		if is_item:
			$Entrance.hide()
			$Item.show()
		else:
			$Entrance.show()
			$Item.hide()

func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_RIGHT \
		and event.is_pressed():
			hide()
			Util.add_hidden(self)
