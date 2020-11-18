extends Label

var count: int = 0

func _ready() -> void:
	Events.connect("entrances_changed", self, "_on_entrances_changed")
	count = len(get_tree().get_nodes_in_group("entrance"))
	text = "%d" % count

func _on_entrances_changed(change: int) -> void:
	count += change
	text = "%d" % count
