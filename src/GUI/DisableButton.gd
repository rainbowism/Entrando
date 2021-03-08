extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.is_pressed():
		match(event.button_index):
			BUTTON_RIGHT:
				set_disabled(!is_disabled())
