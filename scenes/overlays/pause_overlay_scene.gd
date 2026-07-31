class_name PauseOverlayScene
extends Overlay

signal main_menu_request
signal unpause



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event):
	match event.get_class():
		"InputEventKey":
			if Input.is_action_pressed("ui_cancel"):
				unpause.emit()

func _on_main_menu_pressed() -> void:
	
	main_menu_request.emit()


func _on_unpause_button_pressed() -> void:
	unpause.emit()
