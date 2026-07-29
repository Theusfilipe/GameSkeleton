class_name OptionsOverlayScene
extends Overlay

#TODO: Refazer dificuldade como toggle buttons, e usar button group
# TODO: Refazer language como OptionButton

signal close_button_pressed
signal window_mode_toggled(bool)
signal v_sync_toggled(bool)

signal master_volume_changed(float)
signal sfx_volume_changed(float)
signal music_volume_changed(float)

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
	if toggled_on:
		window_mode_toggled.emit(true) #if it was toggled on send true
	else:
		window_mode_toggled.emit(false) #if toggled of send false


func _on_v_sync_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		v_sync_toggled.emit(true) #if it was toggled on send true
	else:
		v_sync_toggled.emit(false) #if toggled of send false


func _on_master_volume_h_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		master_volume_changed.emit(master_volume_h_slider.value)

func _on_sfx_volume_h_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		sfx_volume_changed.emit(sfx_volume_h_slider.value)


func _on_music_h_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		music_volume_changed.emit(music_h_slider.value)
