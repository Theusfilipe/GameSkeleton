extends Node

# NOTE: O master deve se preocupar com os macro-estados do jogo
# exemplo: do title pra game, da game pra results, e por aí vai
# não necessariamente ele vai se preocupar com overlays individuais
# pode ser interessante deixar overlays como responsabildiade das scenes
# de estado onde eles aparecem

@export_file("*.tscn") var main_menu_scene_path : String = "res://scenes/main_menu_scene.tscn"
@export_file("*.tscn") var options_overlay_scene_path : String = "res://scenes/overlays/options_overlay_scene.tscn"
@export_file("*.tscn") var saves_overlay_scene_path : String = "res://scenes/overlays/saves_overlay_scene.tscn"
@export_file("*.tscn") var default_level_scene_path : String = "res://scenes/levels/default_level.tscn"
@export_file("*.tscn") var credits_overlay_scene_path : String = "res://scenes/overlays/credits_overlay_scene.tscn"
@export_file("*.tscn") var pause_overlay_scene_path : String = "res://scenes/overlays/pause_overlay_scene.tscn"

@export_category("Debug")
@export var debug_mode: bool
@export var log: bool


var _instanced_default_level : DefaultLevelScene

var _instanced_pause_overlay_screen : PauseOverlayScene

var _current_scene : Scene
var _current_overlay : Overlay
var _pause_screen : PauseOverlayScene

# TODO: usar uma variável única para guardar "categorias" de estados do jogo
#var _current_scene: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#current_window_mode = Window.mode
	# TODO: Caso seja um estado permanente, mudar no inspector, para fazer parte
	# dos defaults do node
	process_mode = Node.PROCESS_MODE_ALWAYS
	_go_to_main_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	debug()


func _load_main_menu_scene() -> void:
	var _instanced_main_menu_screen : MainMenuScene = load(main_menu_scene_path).instantiate()
	if _current_scene != null:
		_current_scene.queue_free()

	_instanced_main_menu_screen.start_button_pressed.connect(_on_start_button_pressed)
	_instanced_main_menu_screen.saves_button_pressed.connect(_on_saves_button_pressed)
	_instanced_main_menu_screen.options_button_pressed.connect(_on_options_button_pressed)
	_instanced_main_menu_screen.credits_button_pressed.connect(_on_credits_button_pressed)
	_instanced_main_menu_screen.quit_game_button_pressed.connect(_on_quit_game_button_pressed)
	_current_scene = _instanced_main_menu_screen
	add_child(_current_scene)

#region Exemplo de encapsulação da lógica de loading onde
# NOTE: Aqui retornaremos a scene instanciada para que possamos
# nos conectar aos signals dela
# TODO: Implementar loading e fade in/fade out a partir dessa nova lógica

func _change_scene(new_scene: String) -> Scene:
	if _current_scene == null:
		_current_scene = load(new_scene).instantiate()
		return _current_scene
	else:
		get_child(0).queue_free()
		_current_scene = load(new_scene).instantiate()
		return _current_scene

func _change_overlay(new_overlay : String) -> Overlay:
	if _current_overlay == null:
		_current_overlay = load(new_overlay).instantiate()
		return _current_overlay
	else:
		find_child(_current_overlay.name).queue_free()
		_current_overlay = load(new_overlay).instantiate()
		return _current_overlay

#Closes the current overlay
func _on_close_overlay() -> void:
	if _current_overlay != null:
		_current_overlay.queue_free()

func _go_to_main_menu():
	var main_menu_screen: MainMenuScene = _change_scene(main_menu_scene_path)
	main_menu_screen.start_button_pressed.connect(_on_start_button_pressed)
	main_menu_screen.options_button_pressed.connect(_on_options_button_pressed)
	main_menu_screen.saves_button_pressed.connect(_on_saves_button_pressed)
	main_menu_screen.credits_button_pressed.connect(_on_credits_button_pressed)
	main_menu_screen.quit_game_button_pressed.connect(_on_quit_game_button_pressed)
	_current_scene = main_menu_screen
	add_child(_current_scene)

#region Signals
#From Main Menu
func _on_start_button_pressed() -> void :
	var game_scene_screen: DefaultLevelScene = _change_scene(default_level_scene_path)
	game_scene_screen.on_pause_game.connect(_on_pause_game_button)
	add_child(game_scene_screen)

func _on_saves_button_pressed() -> void :
	var instanced_saves_overlay : SavesOverlayScene = _change_overlay(saves_overlay_scene_path)
	instanced_saves_overlay.close_button_pressed.connect(_on_close_overlay)
	_current_overlay = instanced_saves_overlay
	add_child(_current_overlay)
	

func _on_options_button_pressed() -> void :
	var _instanced_options_overlay_screen = _change_overlay(options_overlay_scene_path)
	_instanced_options_overlay_screen.close_button_pressed.connect(_on_close_overlay)
	_current_overlay = _instanced_options_overlay_screen
	add_child(_current_overlay)

#From credits

func _on_credits_button_pressed() -> void:
	var _instanced_credits_overlay_screen = _change_overlay(credits_overlay_scene_path)
	add_child(_instanced_credits_overlay_screen)
	_instanced_credits_overlay_screen.close_button_pressed.connect(_on_close_overlay)



#From Pause Overlay

func _on_unpause() -> void:
	get_tree().paused = false
	_instanced_pause_overlay_screen.queue_free()

func _on_main_menu_requested_from_pause() -> void:
	get_tree().paused = false
	_instanced_pause_overlay_screen.queue_free()
	_load_main_menu_scene()

#From game

func _on_pause_game_button() -> void: #Not implemented yet, it sends back to main menu instead.
	_instanced_pause_overlay_screen = load(pause_overlay_scene_path).instantiate()
	get_tree().paused = true
	add_child(_instanced_pause_overlay_screen)
	_instanced_pause_overlay_screen.unpause.connect(_on_unpause)
	_instanced_pause_overlay_screen.main_menu_request.connect(_on_main_menu_requested_from_pause)








# NOTE: Para reagir a um quit, usar esse modelo
# e propagar a notificação como você fez ali embaixo
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		# auto-save
		pass

#Quit game
func _on_quit_game_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit() 

#endregion

func save():
	var saveables = get_tree().get_nodes_in_group("saveable")


#region Debug

func debug() -> void:
	ImGui.ShowDemoWindow()
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
	ImGui.SeparatorText("Options")
	
	# NOTE: Como pegar string de enum
	var difficulty_string: String = OptionsSettings.Difficulty.keys()[OptionsSettings.selected_difficulty]
	ImGui.Text(difficulty_string)
	
	ImGui.BeginTabBar("Settings#left_tabs_bar")
	if ImGui.BeginTabItem("Video"):
		#if ImGui.Button(str(OptionsSettings.window_mode)):
			#if(OptionsSettings.window_mode == Window.MODE_FULLSCREEN):
				#_on_window_mode_toggled(true) #se estiver fullscreen seta para windowed
			#else:
				#_on_window_mode_toggled(false) # se estiver windowed seta para fullscreen
		#var v_sync_string: String = DisplayServer.VSyncMode.
		#ImGui.Text(str(OptionsSettings.VSync))
			#if(OptionsSettings.VSync == DisplayServer.VSYNC_DISABLED):
				#_on_v_sync_toggled(true) # se estiver vsinc disabled seta para disabled
			#else:
				#_on_v_sync_toggled(false) # se estiver vsinc enabled seta para disabled
		ImGui.EndTabItem()
	
	ImGui.EndTabBar()
	
	ImGui.End()
