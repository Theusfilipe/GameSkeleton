extends Scene


enum Difficulty {
	EASY, 
	MEDIUM, 
	HARD
	}

enum Language {
	ENGLISH,
	PORTUGUESE
}


@export_category("Debug")
@export var debug_mode: bool

var config = ConfigFile.new()
var _window_mode : Window.Mode = Window.MODE_FULLSCREEN
var _VSync : DisplayServer.VSyncMode = DisplayServer.VSYNC_DISABLED


	# TODO usar getters e setters no options 
	#get:
		#return AudioServer.get_bus_index()
	#set(value: float)
		#AudioServer.get_bus_index(0).set_value()
var _master_audio_level : float = 1.0
var _sfx_audio_level : float = 1.0
var _music_audio_level : float = 1.0

var _selected_difficulty : Difficulty = Difficulty.MEDIUM
var _selected_language : Language = Language.ENGLISH

func _ready() -> void:
	var err = config.load("res://config.cfg")
	
	if err != OK:
		return
	
	for section in config.get_sections():
		match section:
			"Video":
				set_window_mode(int(config.get_value("Video", "_window_mode")) as Window.Mode)
				set_VSync(int(config.get_value("Video", "_VSync")) as DisplayServer.VSyncMode)
			"Audio":
				set_master_audio_level(float(config.get_value("Audio", "_master_audio_level")))
				set_sfx_audio_level(float(config.get_value("Audio", "_sfx_audio_level")))
				set_music_audio_level(float(config.get_value("Audio", "_music_audio_level")))
			"Gameplay":
				set_difficulty(int(config.get_value("Gameplay", "_selected_difficulty")) as Difficulty)
				set_language(int(config.get_value("Gameplay", "_selected_language")) as Language) 
			
	

func _process(delta: float) -> void:
	if debug_mode:
		render_debug()

#region Video
func get_window_mode() -> Window.Mode:
	return _window_mode

func set_window_mode(this_mode : Window.Mode):
	_window_mode = this_mode
	var window = get_window()
	window.mode = this_mode

func get_VSync() -> DisplayServer.VSyncMode:
	return _VSync
	
func set_VSync(this_mode : DisplayServer.VSyncMode):
	_VSync = this_mode
	DisplayServer.window_set_vsync_mode(this_mode)
	
#endregion

#region Audio
func get_master_audio_level() -> float:
	return _master_audio_level
	
func set_master_audio_level(value : float) -> void:
	_master_audio_level = value
	AudioServer.set_bus_volume_linear(0,value)

func get_sfx_audio_level() -> float:
	return _sfx_audio_level

func set_sfx_audio_level(value : float) -> void:
	_sfx_audio_level = value
	AudioServer.set_bus_volume_linear(1,value)

func get_music_audio_level() -> float:
	return _music_audio_level
	
func set_music_audio_level(value : float) -> void:
	_music_audio_level = value
	AudioServer.set_bus_volume_linear(2,value)
#endregion

#region Difficulty
func _get_difficulty_string(this_difficulty: Difficulty) -> String:
	var difficulty_string: String = OptionsSettings.Difficulty.keys()[this_difficulty]
	return difficulty_string

func get_difficulty() -> Difficulty:
	return _selected_difficulty

func set_difficulty(this_difficulty : Difficulty):
	_selected_difficulty = this_difficulty
#endregion

#region Language
func _get_language_string(this_language : Language) -> String:
	var language_string : String = OptionsSettings.Language.keys()[this_language]
	return language_string

func get_language() -> Language:
	return _selected_language

func set_language(this_language : Language) -> void:
	_selected_language = this_language
#endregion

func save_configs() -> void:
	#Save all video vars
	config.set_value("Video", "_window_mode", _window_mode)
	config.set_value("Video", "_VSync", _VSync)
	#save all audio vars
	config.set_value("Audio", "_master_audio_level", _master_audio_level)
	config.set_value("Audio", "_sfx_audio_level", _sfx_audio_level)
	config.set_value("Audio", "_music_audio_level", _music_audio_level)
	#save all gameplay vars
	config.set_value("Gameplay", "_selected_difficulty", _selected_difficulty)
	config.set_value("Gameplay", "_selected_language", _selected_language)
	
	# Save it to a file (overwrite if already exists).
	config.save("res://config.cfg")

func render_debug():
	if not debug_mode: return
	ImGui.Begin(name)
	ImGui.Text("Master audio: " + str(_master_audio_level*100))
	ImGui.Text("SFX audio: "+ str(_sfx_audio_level*100))
	ImGui.Text("Music audio: "+ str(_music_audio_level*100))
	ImGui.Text("Selected difficulty: " + _get_difficulty_string(_selected_difficulty))
	ImGui.Text("Selected language: " + _get_language_string(_selected_language) )
	ImGui.End()
