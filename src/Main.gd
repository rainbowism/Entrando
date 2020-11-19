extends Node

onready var marker_scene: PackedScene = preload("res://src/Objects/Marker.tscn")
onready var markers: Node2D = $Markers

func _ready() -> void:
	OS.low_processor_usage_mode = true
	get_tree().set_auto_accept_quit(false)
	$GUILayer/Quit.hide()
	$GUILayer/Quit/Confirmation.connect("confirmed", self, "_on_confirmed")
	$GUILayer/Quit/Confirmation.connect("popup_hide", self, "_on_cancelled")
	$GUILayer/Quit/Confirmation.get_ok().text = "YES."
	$GUILayer/Quit/Confirmation.get_cancel().text = "NO."
	$GUILayer/FileDialog/Dialog.connect("popup_hide", self, "_on_cancelled")
	$GUILayer/FileDialog/Dialog.connect("file_selected", self, "_on_file_selected")
	Events.connect("marker_clicked", self, "generate_marker")
	Events.connect("save_file_clicked", self, "open_save_dialog")
	Events.connect("load_file_clicked", self, "open_load_dialog")

	load_data("res://assets/map/750.json")

func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		$GUILayer/FileDialog.hide()
		$GUILayer/FileDialog/Dialog.hide()
		$GUILayer/Quit.show()
		$GUILayer/Quit/Confirmation.popup()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save"):
		open_save_dialog()
	elif event.is_action_pressed("load"):
		open_load_dialog()

func _on_confirmed() -> void:
	get_tree().quit()

func _on_cancelled() -> void:
	$GUILayer/Quit.hide()
	$GUILayer/FileDialog.hide()

func open_save_dialog() -> void:
	$GUILayer/FileDialog.show()
	$GUILayer/FileDialog/Dialog.mode = FileDialog.MODE_SAVE_FILE
	var date = OS.get_datetime()
	$GUILayer/FileDialog/Dialog.current_path = OS.get_executable_path()
	$GUILayer/FileDialog/Dialog.current_file = "%d-%d-%d.json" % [date.year, date.month, date.day]
	$GUILayer/FileDialog/Dialog.popup()

func open_load_dialog() -> void:
	$GUILayer/FileDialog.show()
	$GUILayer/FileDialog/Dialog.mode = FileDialog.MODE_OPEN_FILE
	$GUILayer/FileDialog/Dialog.current_path = OS.get_executable_path()
	$GUILayer/FileDialog/Dialog.current_file = ""
	$GUILayer/FileDialog/Dialog.popup()

func _on_file_selected(path: String) -> void:
	match($GUILayer/FileDialog/Dialog.mode):
		FileDialog.MODE_SAVE_FILE:
			save_data(path)
		FileDialog.MODE_OPEN_FILE:
			if load_data(path):
				Events.emit_signal("tracker_restarted")

func save_data(path: String) -> bool:
	var data = {
		"light_world": $LightWorld.save_data(),
		"dark_world": $DarkWorld.save_data(),
		"markers": markers.save_data(),
		"notes": $GUILayer/GUI.save_data()
	}
	var save_file = File.new()
	if save_file.open(path, File.WRITE) != OK:
		return false
	save_file.store_string(to_json(data))
	save_file.close()
	return true

func load_data(path: String) -> bool:
	var save_file = File.new()
	if !save_file.file_exists(path):
		return false
	if save_file.open(path, File.READ) != OK:
		return false
	var data = parse_json(save_file.get_as_text())
	$LightWorld.load_data(data.light_world)
	$DarkWorld.load_data(data.dark_world)
	markers.load_data(data.markers)
	$GUILayer/GUI.load_data(data.notes)
	save_file.close()
	return true

func generate_marker(texture: Texture, color: Color, connector: String) -> void:
	if Util.mode != Util.MODE_OW:
		return

	if Util.last_marker and Util.last_marker.is_following:
		Util.last_marker.queue_free()

	var marker = marker_scene.instance()
	marker.modulate = color
	if connector != "":
		marker.add_to_group(connector)
		marker.connector = connector
		marker.is_connector = true
	Util.last_marker = marker
	markers.add_child(marker)
	marker.set_sprite(texture)
