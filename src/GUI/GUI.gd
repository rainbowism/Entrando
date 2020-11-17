extends Control

onready var marker_scene: PackedScene = preload("res://src/Objects/Marker.tscn")
onready var notes_modal = $Container/Notes/Shadow
onready var notes_container = $Container/Notes/Shadow/Container/BG

func _ready() -> void:
	Events.connect("marker_clicked", self, "generate_marker")
	Events.connect("notes_clicked", self, "open_notes")

func generate_marker(texture: Texture, color: Color, connector: String) -> void:
	if Util.mode != Util.MODE_OW:
		return

	var marker = marker_scene.instance()
	marker.modulate = color
	marker.set_sprite(texture)
	if connector != "":
		marker.add_to_group(connector)
		marker.connector = connector
		marker.is_connecter = true
	owner.add_child(marker)

func open_notes(node: Node) -> void:
	for child in notes_container.get_children():
		notes_container.remove_child(child)
	notes_container.add_child(node)
	notes_modal.show()
