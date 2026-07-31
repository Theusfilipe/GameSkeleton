class_name OptionsOverlayScene
extends Overlay

#TODO: Refazer dificuldade como toggle buttons, e usar button group
# TODO: Refazer language como OptionButton

signal close_button_pressed

#video
@onready var window_mode_check_box: CheckBox = %WindowModeCheckBox
@onready var v_sync_check_box: CheckBox = %VSyncCheckBox
#audio
@onready var master_volume_h_slider: HSlider = %MasterVolumeHSlider
@onready var sfx_volume_h_slider: HSlider = %SFXVolumeHSlider
@onready var music_h_slider: HSlider = %MusicHSlider
#gameplay
@onready var easy_button: Button = %EasyButton
@onready var medium_button: Button = %MediumButton
@onready var hard_button: Button = %HardButton
@onready var language_option_button: OptionButton = %LanguageOptionButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OptionsSettings.get_window_mode() == Window.MODE_FULLSCREEN:
		window_mode_check_box.button_pressed = false
	else:
		window_mode_check_box.button_pressed = true
	if OptionsSettings.get_window_mode() == DisplayServer.VSYNC_DISABLED:
		v_sync_check_box.button_pressed = false
	else: 
		v_sync_check_box.button_pressed = true

	master_volume_h_slider.value = OptionsSettings.get_master_audio_level()
	sfx_volume_h_slider.value = OptionsSettings.get_sfx_audio_level()
	music_h_slider.value = OptionsSettings.get_music_audio_level()
	
	match OptionsSettings.get_difficulty():
		OptionsSettings.Difficulty.EASY:
			easy_button.button_pressed = true
		OptionsSettings.Difficulty.MEDIUM:
			medium_button.button_pressed = true
		OptionsSettings.Difficulty.HARD:
			hard_button.button_pressed = true

	#meio desnecessário já que dá pra fazer language_option_button.selected = OptionsSettings.Language.ENGLISH
	#DESDE QUE A LISTA DE LANGUAGE OPTION BUTTON ESTEJA ORDENADA IGUAL AO OptionsSettings.Language
	match OptionsSettings.get_language():
		OptionsSettings.Language.ENGLISH:
			language_option_button.selected = 0
		OptionsSettings.Language.PORTUGUESE:
			language_option_button.selected = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.

#func _process(delta: float) -> void:
#	pass


func _on_close_overlay_button_pressed() -> void:
	OptionsSettings.save_configs()
	close_button_pressed.emit()


#region Video
func _on_window_mode_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		OptionsSettings.set_window_mode(Window.MODE_WINDOWED)
	else:
		OptionsSettings.set_window_mode(Window.MODE_FULLSCREEN)


func _on_v_sync_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		OptionsSettings.set_VSync(DisplayServer.VSYNC_ENABLED)
	else:
		OptionsSettings.set_VSync(DisplayServer.VSYNC_DISABLED)
#endregion
#region Volume
func _on_master_volume_h_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		OptionsSettings.set_master_audio_level(master_volume_h_slider.value)

func _on_sfx_volume_h_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		OptionsSettings.set_sfx_audio_level(sfx_volume_h_slider.value)

func _on_music_h_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		OptionsSettings.set_music_audio_level(music_h_slider.value)
#endregion
#region Gameplay
func _on_difficulty_button_toggled(toggled_on: bool, source: BaseButton) -> void:
	if toggled_on :
		if source.name == "EasyButton":
			OptionsSettings.set_difficulty(OptionsSettings.Difficulty.EASY)
		elif source.name == "MediumButton":
			OptionsSettings.set_difficulty(OptionsSettings.Difficulty.MEDIUM)
		elif source.name == "HardButton":
			OptionsSettings.set_difficulty(OptionsSettings.Difficulty.HARD)
		else:
			print("No valid difficulty selected")

func _on_language_option_button_item_selected(index: int) -> void:
	if index == 0:
		OptionsSettings.set_language(OptionsSettings.Language.PORTUGUESE)
	elif index == 1:
		OptionsSettings.set_language(OptionsSettings.Language.ENGLISH)
	else:
		print("No valid language selected")
#endregion
