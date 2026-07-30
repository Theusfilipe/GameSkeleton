class_name OptionsOverlayScene
extends Overlay

#TODO: Refazer dificuldade como toggle buttons, e usar button group
# TODO: Refazer language como OptionButton

signal close_button_pressed


@onready var window_mode_check_box: CheckBox = %WindowModeCheckBox
@onready var v_sync_check_box: CheckBox = %VSyncCheckBox

@onready var master_volume_h_slider: HSlider = %MasterVolumeHSlider
@onready var sfx_volume_h_slider: HSlider = %SFXVolumeHSlider
@onready var music_h_slider: HSlider = %MusicHSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OptionsSettings.window_mode == Window.MODE_FULLSCREEN:
		window_mode_check_box.button_pressed = false
	else:
		window_mode_check_box.button_pressed = true
	if OptionsSettings.VSync == DisplayServer.VSYNC_DISABLED:
		v_sync_check_box.button_pressed = false
	else: 
		v_sync_check_box.button_pressed = true
	master_volume_h_slider.value = OptionsSettings.master_audio_level
	sfx_volume_h_slider.value = OptionsSettings.sfx_audio_level
	music_h_slider.value = OptionsSettings.music_audio_level
# Called every frame. 'delta' is the elapsed time since the previous frame.

#func _process(delta: float) -> void:
#	pass


func _on_close_overlay_button_pressed() -> void:
	close_button_pressed.emit()



func _on_window_mode_check_box_toggled(toggled_on: bool) -> void:
	var window = get_window()
	if toggled_on:
		window.mode = Window.MODE_WINDOWED
		OptionsSettings.window_mode = Window.MODE_WINDOWED
	else:
		window.mode = Window.MODE_FULLSCREEN
		OptionsSettings.window_mode = Window.MODE_FULLSCREEN


func _on_v_sync_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		OptionsSettings.VSync = DisplayServer.VSYNC_ENABLED
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		OptionsSettings.VSync = DisplayServer.VSYNC_DISABLED


func _on_master_volume_h_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		OptionsSettings.master_audio_level = master_volume_h_slider.value

func _on_sfx_volume_h_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		OptionsSettings.music_audio_level = sfx_volume_h_slider.value


func _on_music_h_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		OptionsSettings.sfx_audio_level = music_h_slider.value


func _on_difficulty_button_toggled(toggled_on: bool, source: BaseButton) -> void:
	if toggled_on :
		if source.name == "EasyButton":
			OptionsSettings.selected_difficulty = OptionsSettings.Difficulty.EASY
		elif source.name == "MediumButton":
			OptionsSettings.selected_difficulty = OptionsSettings.Difficulty.MEDIUM
		elif source.name == "HardButton":
			OptionsSettings.selected_difficulty = OptionsSettings.Difficulty.HARD
