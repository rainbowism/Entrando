extends Node

func _ready() -> void:
	OS.low_processor_usage_mode = true
	get_tree().set_auto_accept_quit(false)
	$GUILayer/Quit.hide()
	$GUILayer/Quit/Confirmation.connect("confirmed", self, "_on_confirmed")
	$GUILayer/Quit/Confirmation.connect("popup_hide", self, "_on_cancelled")
	$GUILayer/Quit/Confirmation.get_cancel().connect("pressed", self, "_on_cancelled")
	$GUILayer/Quit/Confirmation.get_ok().text = "YES."
	$GUILayer/Quit/Confirmation.get_cancel().text = "NO."

func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		$GUILayer/Quit.show()
		$GUILayer/Quit/Confirmation.popup()

func _on_confirmed() -> void:
	get_tree().quit()

func _on_cancelled() -> void:
	$GUILayer/Quit.hide()
