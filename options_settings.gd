extends Node

# NOTE: Sempre busque criar singletons usando scenes
# para ter acesso a @export e outras coisas legais

enum Difficulty {
	EASY, 
	MEDIUM, 
	HARD
	}



@export_category("Debug")
@export var debug_mode: bool
@export var log: bool

var window_mode : Window.Mode = Window.MODE_FULLSCREEN
var VSync : DisplayServer.VSyncMode = DisplayServer.VSYNC_DISABLED

var master_audio_level : float = 100
	# TODO usar getters e setters no options 
	#get:
		#return AudioServer.get_bus_index()
	#set(value: float)
		#AudioServer.get_bus_index(0).set_value()

var sfx_audio_level : float = 100
var music_audio_level : float = 100
var selected_difficulty : Difficulty = Difficulty.MEDIUM

func _process(delta: float) -> void:
	render_debug()


func _get_difficulty_name(difficulty: Difficulty):
	# TODO: implementar usando enums como um dicionário
	pass


# TODO: Completar esse debug
# pode ser apenas monitoramento
func render_debug():
	if not debug_mode: return
	ImGui.Begin(name)
	ImGui.Text(str(master_audio_level))
	ImGui.Text(str(sfx_audio_level))
	ImGui.Text(str(music_audio_level))
	ImGui.End()
