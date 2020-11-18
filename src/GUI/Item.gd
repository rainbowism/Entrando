extends HBoxContainer

#var colors: PoolColorArray = PoolColorArray([
#	Color8(235,72,83),
#	Color8(96,202,96),
#	Color8(193,95,221),
#	Color8(182,225,73),
#	Color8(216,115,178),
#	Color8(213,188,63),
#	Color8(119,147,220),
#	Color8(222,117,49),
#	Color8(95,204,175),
#	Color8(216,119,116),
#	Color8(154,179,100),
#	Color8(198,151,87)
#])

onready var arrow_icon_scene: PackedScene = preload("res://src/GUI/ArrowIcon.tscn")
onready var icons: HBoxContainer = $Icons

func connect_children(node: Node) -> void:
	for child in node.get_children():
		if child.get_child_count() > 0:
			connect_children(child)
		elif child is TextureButton:
			child.connect("pressed", self, "add_arrow", [child.texture_normal])

func _ready() -> void:
	$Icons/ItemIcon.connect("gui_input", self, "_item_gui_input")
	connect_children($Compass)

func set_item(texture: Texture) -> void:
	$Icons/ItemIcon.texture_normal = texture

func add_arrow(texture: Texture) -> void:
	var arrow = arrow_icon_scene.instance()
	arrow.texture = texture
#	arrow.modulate = colors[(icons.get_child_count()-1) % len(colors)]
	icons.add_child(arrow)

func _item_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_RIGHT \
		and event.is_pressed():
		queue_free()
