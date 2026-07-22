class_name OptionsOverlayScene
extends Control

signal close_button_pressed
signal window_mode_toggled(bool)
signal v_sync_toggled(bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_overlay_button_pressed() -> void:
	close_button_pressed.emit()



func _on_window_mode_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		window_mode_toggled.emit(true) #if it was toggled on send true
	else:
		window_mode_toggled.emit(false) #if toggled of send false


func _on_v_sync_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		v_sync_toggled.emit(true) #if it was toggled on send true
	else:
		v_sync_toggled.emit(false) #if toggled of send false
