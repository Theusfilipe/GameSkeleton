class_name CreditsOverlayScene
extends Overlay

signal close_button_pressed



func _on_close_button_pressed() -> void:
	close_button_pressed.emit()
