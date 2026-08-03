class_name DefaultLevelScene
extends Scene

# TODO: implementar um overlayzinho de instruções que pode ser fechado
# com esc sem abrir o pause imediatamente. _input e _unhandled_input
# guardam a resposta para esse enigma

signal on_pause_game

var paused : bool = false

var player_speed := [1.0]

var loops = 0

@onready var player: Player = %Player

@onready var trampoline_player: AudioStreamPlayer = %TrampolinePlayer

@onready var loops_label: Label = %LoopsLabel

func initialize(loops: int):
	self.loops = loops

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	debug()
	if paused:
		paused = false
	if player.position.x > 1100:
		trampoline_player.play()
	if player.position.x > 1150:
		player.position.x = -30
		loops +=1
		loops_label.text = str(loops)

func _unhandled_input(event):
	match event.get_class():
		"InputEventKey":
			if Input.is_action_pressed("ui_cancel"):
				if !paused: #se não estiver pausado pausar
					paused = true
					on_pause_game.emit()
				else:
					return
#region Save
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"loops" : loops, 
	}
	return save_dict
#endregion

#region Signals
func _on_pause_button_pressed() -> void:
	paused = true
	on_pause_game.emit()
#endregion
#region Debug

func debug() -> void:
	ImGui.Begin("Gameplay")
	player_speed[0] = player.speed
	ImGui.DragFloat("Player speed", player_speed)
	player.speed = player_speed[0]
	ImGui.End()
	
