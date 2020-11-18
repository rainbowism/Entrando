extends Control

enum {
	MENU_OW_ITEMS = 0,
	MENU_DRAG_N_DROP = 1,
	MENU_REMAINING_ENTRANCES = 2,
	MENU_RESET = 4
}

onready var marker_scene: PackedScene = preload("res://src/Objects/Marker.tscn")
onready var menu = $PopupMenu
onready var notes_modal = $Container/Notes/Shadow
onready var notes_container = $Container/Notes/Shadow/Container/BG

func _ready() -> void:
	Events.connect("marker_clicked", self, "generate_marker")
	Events.connect("notes_clicked", self, "open_notes")
	menu.connect("id_pressed", self, "menu_pressed")

	menu.add_item("Hide OW Item Markers", MENU_OW_ITEMS)
	menu.add_check_item("Drag n' Drop Markers", MENU_DRAG_N_DROP)
	menu.add_check_item("Show Remaining Entrances", MENU_REMAINING_ENTRANCES)
	menu.add_separator()
	menu.add_item("!!RESET!!", MENU_RESET)

func generate_marker(texture: Texture, color: Color, connector: String) -> void:
	if Util.mode != Util.MODE_OW:
		return

	if Util.last_marker and Util.last_marker.is_following:
		Util.last_marker.queue_free()

	var marker = marker_scene.instance()
	marker.modulate = color
	marker.set_sprite(texture)
	if connector != "":
		marker.add_to_group(connector)
		marker.connector = connector
		marker.is_connecter = true
	Util.last_marker = marker
	owner.add_child(marker)

func open_notes(node: Node) -> void:
	for child in notes_container.get_children():
		notes_container.remove_child(child)
	notes_container.add_child(node)
	notes_modal.show()

func open_menu() -> void:
	menu.popup()
	menu.rect_global_position = get_global_mouse_position() - menu.rect_size

func menu_pressed(id: int) -> void:
	if menu.is_item_checkable(id):
		menu.set_item_checked(id, !menu.is_item_checked(id))
	match(id):
		MENU_OW_ITEMS:
			get_tree().call_group("item", "queue_free")
		MENU_DRAG_N_DROP:
			Util.drag_and_drop = menu.is_item_checked(id)
		MENU_REMAINING_ENTRANCES:
			$"Container/Margin/Rows/2/EntranceCounter".visible = menu.is_item_checked(id)
		MENU_RESET:
			get_tree().reload_current_scene()
