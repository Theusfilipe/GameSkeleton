extends Node

enum Difficulty {
	EASY, 
	MEDIUM, 
	HARD
	}

var window_mode : Window.Mode = Window.MODE_FULLSCREEN
var VSync : DisplayServer.VSyncMode = DisplayServer.VSYNC_DISABLED

var master_audio_level : float = 100
var sfx_audio_level : float = 100
var music_audio_level : float = 100
var selected_difficulty : Difficulty = Difficulty.MEDIUM
