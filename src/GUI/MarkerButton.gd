extends TextureButton

export(String,
	"",
	"hc",
	"ep",
	"dp",
	"th",
	"at",
	"pd",
	"sp",
	"sw",
	"tt",
	"ip",
	"mm",
	"tr",
	"gt",
	"ganon",
	"spec",
	"paradox",
	"bunny",
	"bumper",
	"brother",
	"granny",
	"fairy",
	"keese",
	"oldman",
	"mountain",
	"spiral",
	"sick_kid",
	"sriracha",
	"spike",
	"potion_shop",
	"smith",
	"library"
) var connector
var is_hovering: bool = false

func _ready() -> void:
	connect("button_down", self, "_on_pressed")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")

func _draw() -> void:
	if connector == "":
		return
	if !visible:
		return
	if !is_hovering:
		return

	for node in get_tree().get_nodes_in_group(connector):
		if node == self \
			or !node.visible \
			or node.is_following:
			continue
		draw_line(
			rect_size / 2,
			node.global_position - rect_global_position,
			Color.red,
			2, true
		)

func _on_pressed() -> void:
	Events.emit_signal("marker_clicked", texture_normal, modulate, connector)

func _on_mouse_entered() -> void:
	is_hovering = true
	update()

func _on_mouse_exited() -> void:
	is_hovering = false
	update()
