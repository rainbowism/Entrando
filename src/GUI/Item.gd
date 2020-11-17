extends HBoxContainer

onready var arrow_icon_scene: PackedScene = preload("res://src/GUI/ArrowIcon.tscn")
onready var icons: HBoxContainer = $Icons

func _ready() -> void:
	$Icons/ItemIcon.connect("gui_input", self, "_item_gui_input")
	for row in $Compass.get_children():
		for child in row.get_children():
			child.connect("pressed", self, "add_arrow", [child.texture_normal])

func set_item(texture: Texture) -> void:
	$Icons/ItemIcon.texture_normal = texture

func add_arrow(texture: Texture) -> void:
	var arrow = arrow_icon_scene.instance()
	arrow.texture = texture
	icons.add_child(arrow)

func _item_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_RIGHT \
		and event.is_pressed():
		queue_free()
