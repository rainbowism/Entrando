extends Control

enum {
	MENU_RESET = 0,
	# 1 separator
	MENU_SAVE_FILE = 2,
	MENU_LOAD_FILE = 3,
	# 4 separator
	MENU_REMAINING_ENTRANCES = 5,
	MENU_DRAG_N_DROP = 6,
	MENU_OW_ITEMS = 7
}

onready var menu = $PopupMenu
onready var tooltip = $TooltipPopup
onready var tooltip_timer = $TooltipPopup/Timer
onready var notes_modal = $Container/Notes/Shadow
onready var notes_container = $Container/Notes/Shadow/Container/BG

func _ready() -> void:
	Events.connect("notes_clicked", self, "open_notes")
	menu.connect("id_pressed", self, "menu_pressed")

	menu.add_item("!!RESET!!", MENU_RESET)
	menu.add_separator()
	menu.add_item("Save", MENU_SAVE_FILE)
	menu.add_item("Load", MENU_LOAD_FILE)
	menu.add_separator()
	menu.add_check_item("Show Remaining Entrances", MENU_REMAINING_ENTRANCES)
	menu.add_check_item("Drag n' Drop Markers", MENU_DRAG_N_DROP)
	menu.add_item("Hide OW Item Markers", MENU_OW_ITEMS)

	for child in get_tree().get_nodes_in_group(Util.GROUP_NOTES):
		print(child.name)
		child.connect("mouse_entered", self, "_on_notes_entered", [child])
		child.connect("mouse_exited", self, "_on_notes_exited")

func save_data() -> Dictionary:
	var data = {}
	for child in get_tree().get_nodes_in_group(Util.GROUP_NOTES):
		data[child.name] = child.save_data()
	return data

func load_data(data: Dictionary) -> void:
	var nodes = {}
	for child in get_tree().get_nodes_in_group(Util.GROUP_NOTES):
		nodes[child.name] = child
	for id in data:
		nodes[id].load_data(data[id])

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
			get_tree().call_group(Util.GROUP_ITEMS, "queue_free")
		MENU_DRAG_N_DROP:
			Util.drag_and_drop = menu.is_item_checked(id)
		MENU_REMAINING_ENTRANCES:
			$"Container/Margin/NotesButtons/2/EntranceCounter".visible = menu.is_item_checked(id)
		MENU_SAVE_FILE:
			Events.emit_signal("save_file_clicked")
		MENU_LOAD_FILE:
			Events.emit_signal("load_file_clicked")
		MENU_RESET:
			get_tree().reload_current_scene()

func _on_notes_entered(node: Node) -> void:
	print("hello")
	for item in node.notes_tab.item_container.get_children():
		var sprite = TextureRect.new()
		sprite.texture = item.icons.get_child(0).texture
		tooltip.add_child(sprite)
	tooltip.popup()
	tooltip.rect_global_position = get_global_mouse_position() - tooltip.rect_size

func _on_notes_exited() -> void:
	print("hello")
	tooltip.hide()
	for child in tooltip.get_children():
		child.queue_free()
