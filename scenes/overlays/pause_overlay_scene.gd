class_name PauseOverlayScene
extends Overlay

signal main_menu_request
signal unpause
signal options_menu_request
signal save

var overlay_open : bool = false

func _ready() -> void:
	pass

func _unhandled_input(event):
	match event.get_class():
		"InputEventKey":
			if !overlay_open :
				if Input.is_action_pressed("ui_cancel"):
					unpause.emit()



func _on_main_menu_pressed() -> void:
	
	main_menu_request.emit()


func _on_unpause_button_pressed() -> void:
	unpause.emit()


func _on_options_button_pressed() -> void:
	overlay_open = true
	options_menu_request.emit()


func _on_save_button_pressed() -> void:
	save.emit()
	pass # Replace with function body.
