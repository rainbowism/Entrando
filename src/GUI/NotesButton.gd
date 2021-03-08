extends MarginContainer

var current_checks: int setget set_current_checks
export var total_checks: int setget set_total_checks
export var icon: Texture
export var locked_total_checks: bool

var notes_tab: HSplitContainer

onready var notes_tab_scene: PackedScene = preload("res://src/GUI/NotesTab.tscn")
onready var item_note_scene: PackedScene = preload("res://src/GUI/ItemNote.tscn")
onready var label: Label = $Label

func _ready() -> void:
	update_label()
	add_to_group(Util.GROUP_NOTES)
	$Texture.texture = icon
	notes_tab = notes_tab_scene.instance()
	notes_tab.attach_notes(self)
	Events.connect("marker_clicked", self, "_on_marker_clicked")

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.is_pressed():
		match(event.button_index):
			BUTTON_LEFT:
				Events.emit_signal("mode_changed", Util.MODE_DUNGEON)
				Events.emit_signal("notes_clicked", notes_tab)
			BUTTON_RIGHT:
				current_checks += 1
				if current_checks > total_checks:
					current_checks = total_checks
				set_current_checks(current_checks)
			BUTTON_WHEEL_UP:
				set_total_checks(total_checks + 1)
			BUTTON_WHEEL_DOWN:
				set_total_checks(total_checks - 1)
				if current_checks > total_checks:
					current_checks = total_checks
				set_current_checks(current_checks)

func save_data() -> Dictionary:
	var data = {
		"current_checks": current_checks,
		"total_checks": total_checks,
		"notes": notes_tab.text,
		"paths": []
	}

	for item in notes_tab.item_container.get_children():
		var path = []
		for icon_node in item.icons.get_children():
			path.append(icon_node.texture.resource_path)
		data.paths.append(path)

	return data

func load_data(data: Dictionary) -> void:
	current_checks = data.current_checks
	notes_tab.current_slider.value = current_checks
	total_checks = data.total_checks
	notes_tab.total_slider.value = total_checks
	notes_tab.text = data.notes
	for child in notes_tab.item_container.get_children():
		child.queue_free()
	for path in data.paths:
		var item_note = add_item_note(load(path[0]))
		for i in range(1, len(path)):
			item_note.add_arrow(load(path[i]))
	update_label()

func update_label() -> void:
	label.text = "%d/%d" % [current_checks, total_checks]

func set_current_checks(value: int) -> void:
	current_checks = value
	notes_tab.current_slider.value = current_checks
	if label:
		update_label()

func set_total_checks(value: int) -> void:
	if !locked_total_checks:
		total_checks = value

	if label:
		update_label()

func _current_checks_changed(value: int) -> void:
	current_checks = value
	if current_checks > total_checks:
		current_checks = total_checks
		notes_tab.current_slider.value = total_checks
	if label:
		update_label()

func _total_checks_changed(value: int) -> void:
	total_checks = value
	if label:
		update_label()

func _on_marker_clicked(texture: Texture, _color: Color, _connector: String) -> void:
	if Util.mode != Util.MODE_DUNGEON:
		return
	if !notes_tab.is_inside_tree():
		return

	add_item_note(texture)

func add_item_note(texture: Texture) -> HBoxContainer:
	var item_note = item_note_scene.instance()
	item_note.init()
	item_note.set_item(texture)
	notes_tab.item_container.add_child(item_note)
	return item_note
