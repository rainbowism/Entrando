extends HSplitContainer

var current_label: Label
var current_slider: HSlider
var total_label: Label
var total_slider: HSlider

onready var item_container: VBoxContainer = $ItemsMargin/Paths/ScrollContainer/Items

func _enter_tree() -> void:
	total_label.text = "%d" % total_slider.value
	current_label.text = "%d" % min(current_slider.value, total_slider.value)

func attach_notes(parent: Node) -> void:
	current_slider = $NotesMargin/VBoxContainer/Current/Slider
	current_slider.value = parent.current_checks
	current_slider.connect("value_changed", self, "_current_checks_changed")
	current_slider.connect("value_changed", parent, "_current_checks_changed")
	total_slider = $NotesMargin/VBoxContainer/Total/Slider
	total_slider.value = parent.total_checks
	total_slider.connect("value_changed", self, "_total_checks_changed")
	total_slider.connect("value_changed", parent, "_total_checks_changed")
	total_label = $NotesMargin/VBoxContainer/Total/Label
	total_label.text = "%d" % total_slider.value
	current_label = $NotesMargin/VBoxContainer/Current/Label
	current_label.text = "%d" % min(current_slider.value, total_slider.value)

func _current_checks_changed(_value: int) -> void:
	current_label.text = "%d" % min(current_slider.value, total_slider.value)

func _total_checks_changed(_value: int) -> void:
	total_label.text = "%d" % total_slider.value
