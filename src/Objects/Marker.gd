extends Area2D

var connector: String = ""
var is_following: bool = true
var is_connecter: bool = false
var is_hovering: bool = false

func _ready() -> void:
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	add_to_group("marker")

func _process(_delta: float) -> void:
	if is_following:
		global_position = get_global_mouse_position()

func set_sprite(texture: Texture) -> void:
	$Sprite.texture = texture

func _draw() -> void:
	if connector == "":
		return
	if !visible:
		return
	if is_following:
		return
	if !is_hovering:
		return

	for node in get_tree().get_nodes_in_group(connector):
		if node == self \
			or !node.visible:
			continue
		draw_line(
			Vector2.ZERO,
			node.global_position - global_position,
			Color.red,
			2, true
		)

func _input(event: InputEvent) -> void:
	if !Util.drag_and_drop:
		return

	if event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and !event.is_pressed():
			is_following = false
			if global_position.y > 750:
				queue_free()

func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			is_following = event.is_pressed()
			if !is_following and global_position.y > 750:
				queue_free()
		elif event.button_index == BUTTON_RIGHT \
			and event.is_pressed():
			hide()
			Util.add_hidden(self)

func _on_mouse_entered() -> void:
	is_hovering = true
	update()

func _on_mouse_exited() -> void:
	is_hovering = false
	update()
