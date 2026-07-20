extends Node

@export_file("*.tscn") var main_menu_scene_path : String = "res://scenes/main_menu_scene.tscn"
@export_file("*.tscn") var options_overlay_scene_path : String = "res://scenes/overlays/options_overlay_scene.tscn"
@export_file("*.tscn") var default_level_scene_path : String = "res://scenes/levels/default_level.tscn"

var _instanced_main_menu_screen : MainMenuScene
var _instanced_options_overlay_screen : OptionsOverlayScene
var _instanced_default_level : DefaultLevelScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_main_menu_scene()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _load_main_menu_scene() -> void:
	_instanced_main_menu_screen = load(main_menu_scene_path).instantiate()
	if get_child_count() == 0:
		add_child(_instanced_main_menu_screen)
	else:
		var current_scene = get_child(0)
		add_child(_instanced_main_menu_screen)
		current_scene.queue_free()
	
	_instanced_main_menu_screen.start_button_pressed.connect(_on_start_button_pressed)
	_instanced_main_menu_screen.saves_button_pressed.connect(_on_saves_button_pressed)
	_instanced_main_menu_screen.options_button_pressed.connect(_on_options_button_pressed)
	_instanced_main_menu_screen.credits_button_pressed.connect(_on_credits_button_pressed)


#region Signals
#From Main Menu
func _on_start_button_pressed() -> void :
	_instanced_default_level = load(default_level_scene_path).instantiate()
	if get_child_count() == 0:
		add_child(_instanced_default_level)
	else:
		var current_scene = get_child(0)
		add_child(_instanced_default_level)
		current_scene.queue_free()
	pass

func _on_saves_button_pressed() -> void :
	pass

func _on_options_button_pressed() -> void :
	_instanced_options_overlay_screen = load(options_overlay_scene_path).instantiate()
	add_child(_instanced_options_overlay_screen)
	_instanced_options_overlay_screen.close_button_pressed.connect(_on_close_options_overlay_button)
	
func _on_credits_button_pressed() -> void:
	pass

#From Options
func _on_close_options_overlay_button() -> void:
	_instanced_options_overlay_screen.queue_free()
	
#endregion
