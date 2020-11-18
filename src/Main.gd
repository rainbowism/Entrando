extends Node

onready var marker_scene: PackedScene = preload("res://src/Objects/Marker.tscn")
onready var markers: Node2D = $Markers

func _ready() -> void:
	OS.low_processor_usage_mode = true
	get_tree().set_auto_accept_quit(false)
	$GUILayer/Quit.hide()
	$GUILayer/Quit/Confirmation.connect("confirmed", self, "_on_confirmed")
	$GUILayer/Quit/Confirmation.connect("popup_hide", self, "_on_cancelled")
	$GUILayer/Quit/Confirmation.get_cancel().connect("pressed", self, "_on_cancelled")
	$GUILayer/Quit/Confirmation.get_ok().text = "YES."
	$GUILayer/Quit/Confirmation.get_cancel().text = "NO."
	Events.connect("marker_clicked", self, "generate_marker")

	load_data("res://assets/map/750.json")

func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		$GUILayer/Quit.show()
		$GUILayer/Quit/Confirmation.popup()

func _on_confirmed() -> void:
	get_tree().quit()

func _on_cancelled() -> void:
	$GUILayer/Quit.hide()

func save_data() -> Dictionary:
	return {
		"light_world": $LightWorld.save_data(),
		"dark_world": $DarkWorld.save_data(),
		"markers": $Markers.save_data()
	}

func load_data(path: String) -> bool:
	var save_game = File.new()
	if !save_game.file_exists(path):
		return false
	save_game.open(path, File.READ)
	var data = parse_json(save_game.get_as_text())
	$LightWorld.load_data(data.light_world)
	$DarkWorld.load_data(data.dark_world)
	markers.load_data(data.markers)
	save_game.close()
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
