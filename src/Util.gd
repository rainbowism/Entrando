extends Node

enum {MODE_OW, MODE_DUNGEON}

const GROUP_MARKER = "markers"
const GROUP_ITEMS = "items"
const GROUP_ENTRANCES = "entrances"
const GROUP_NOTES = "notes_buttons"

var mode: int = MODE_OW
# only shows entrances, and not OW items
var andy_mode: bool = false
# enables drag and dropping markers
var drag_and_drop: bool = false
var nodes_hidden: Array = []
var last_marker

func _ready() -> void:
	Events.connect("tracker_restarted", self, "_on_tracker_restarted")
	Events.connect("mode_changed", self, "_on_mode_changed")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("undo") \
		and len(nodes_hidden) > 0:
		var node = nodes_hidden[len(nodes_hidden) - 1]
		node.show()
		nodes_hidden.erase(node)
		Events.emit_signal("entrances_changed", 1)

func add_hidden(node: Node) -> void:
	nodes_hidden.append(node)
	if len(nodes_hidden) > 10:
		var to_delete = nodes_hidden[0]
		nodes_hidden.erase(to_delete)
		if is_instance_valid(to_delete):
			to_delete.queue_free()
	Events.emit_signal("entrances_changed", -1)

func _on_tracker_restarted() -> void:
	nodes_hidden.clear()

func _on_mode_changed(new_mode: int) -> void:
	mode = new_mode
