class_name MainMenuScene
extends Scene

signal start_button_pressed
signal saves_button_pressed
signal options_button_pressed
signal credits_button_pressed
signal quit_game_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_start_button_pressed() -> void:
	start_button_pressed.emit()


func _on_saves_button_pressed() -> void:
	saves_button_pressed.emit()


func _on_options_button_pressed() -> void:
	options_button_pressed.emit()


func _on_credits_button_pressed() -> void:
	credits_button_pressed.emit()


func _on_quit_game_button_pressed() -> void:
	quit_game_button_pressed.emit()
