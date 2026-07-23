extends Node

@export_file("*.tscn") var main_menu_scene_path : String = "res://scenes/main_menu_scene.tscn"
@export_file("*.tscn") var options_overlay_scene_path : String = "res://scenes/overlays/options_overlay_scene.tscn"
@export_file("*.tscn") var saves_overlay_scene_path : String = "res://scenes/overlays/saves_overlay_scene.tscn"
@export_file("*.tscn") var default_level_scene_path : String = "res://scenes/levels/default_level.tscn"
@export_file("*.tscn") var credits_overlay_scene_path : String = "res://scenes/overlays/credits_overlay_scene.tscn"

var _instanced_main_menu_screen : MainMenuScene
var _instanced_options_overlay_screen : OptionsOverlayScene
var _instanced_default_level : DefaultLevelScene
var _instanced_saves_overlay_screen : SavesOverlayScene
var _instanced_credits_overlay_screen : CreditsOverlayScene


var myfloat := [0.0]
var mystr := [""]
var values := [2.0, 4.0, 0.0, 3.0, 1.0, 5.0]
var items := ["zero", "one", "two", "three", "four", "five"]
var current_item := [2]
var anim_counter := 0
var wc_topmost: ImGuiWindowClassPtr
var ms_items := items
var ms_selection := []
var table_items := []



# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	_load_main_menu_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	debug()


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
	_instanced_main_menu_screen.quit_game_button_pressed.connect(_on_quit_game_button_pressed)

#region Signals
#From Main Menu
func _on_start_button_pressed() -> void :
	if _instanced_default_level == null:
		_instanced_default_level = load(default_level_scene_path).instantiate()
		if get_child_count() == 0:
			add_child(_instanced_default_level)
		else:
			var current_scene = get_child(0)
			add_child(_instanced_default_level)
			current_scene.queue_free()
	else:
		print("_instanced_default_level is instantiated")

func _on_saves_button_pressed() -> void :
	if _instanced_saves_overlay_screen == null :
		_instanced_saves_overlay_screen = load(saves_overlay_scene_path).instantiate()
		add_child(_instanced_saves_overlay_screen)
		_instanced_saves_overlay_screen.close_button_pressed.connect(_on_close_save_overlay_button)
	else:
		print("_instanced_saves_overlay_screen is instantiated")

func _on_options_button_pressed() -> void :
	if _instanced_options_overlay_screen == null :
		_instanced_options_overlay_screen = load(options_overlay_scene_path).instantiate()
		add_child(_instanced_options_overlay_screen)
		_instanced_options_overlay_screen.close_button_pressed.connect(_on_close_options_overlay_button)
		_instanced_options_overlay_screen.window_mode_toggled.connect(_on_window_mode_toggled)
		_instanced_options_overlay_screen.v_sync_toggled.connect(_on_v_sync_toggled)
	else:
		print("_instanced_options_overlay_screen is instantiated")


#From Options
func _on_close_options_overlay_button() -> void:
	if _instanced_options_overlay_screen == null :
		print("_instanced_options_overlay_screen is not instantiated")
	else:
		_instanced_options_overlay_screen.queue_free()

func _on_window_mode_toggled(response : bool) -> void:
	var window = get_window()
	if response:
		window.mode = Window.MODE_WINDOWED
	else:
		window.mode = Window.MODE_FULLSCREEN
		
func _on_v_sync_toggled(response : bool) -> void:
	if response:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

#From Saves
func _on_close_save_overlay_button() -> void:
	_instanced_saves_overlay_screen.queue_free()

#From credits

func _on_credits_button_pressed() -> void:
	if _instanced_credits_overlay_screen == null :
		_instanced_credits_overlay_screen = load(credits_overlay_scene_path).instantiate()
		add_child(_instanced_credits_overlay_screen)
		_instanced_credits_overlay_screen.close_button_pressed.connect(_on_close_credits_overlay_button)
	else:
		print("_instanced_credits_overlay_screen is instantiated")

func _on_close_credits_overlay_button() -> void:
	_instanced_credits_overlay_screen.queue_free()



#Quit game
func _on_quit_game_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit() 
#endregion


#region Debug

func debug() -> void:
	
	ImGui.Begin("ImGui")
	ImGui.Text(get_child(0).name)
	if ImGui.Button("Start game"):
		_on_start_button_pressed()
	if ImGui.Button("Saves"):
		_on_saves_button_pressed()
	if ImGui.Button("Options"):
		_on_options_button_pressed()
	if ImGui.Button("Credits"):
		_on_credits_button_pressed()
	if ImGui.Button("Quit"):
		_on_quit_game_button_pressed()
	ImGui.End()
	
