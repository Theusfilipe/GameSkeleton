class_name PauseOverlayScene
extends Control

signal main_menu_request
signal pause
signal unpause

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause.emit()
	process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_menu_pressed() -> void:
	main_menu_request.emit()


func _on_unpause_button_pressed() -> void:
	unpause.emit()
