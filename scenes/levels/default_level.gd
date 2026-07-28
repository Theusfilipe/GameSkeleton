class_name DefaultLevelScene
extends Node

# TODO: implementar um overlayzinho de instruções que pode ser fechado
# com esc sem abrir o pause imediatamente. _input e _unhandled_input
# guardam a resposta para esse enigma

signal on_pause_game

var player_speed := [1.0]

var loops = 0

@onready var player: Player = %Player

@onready var trampoline_player: AudioStreamPlayer = %TrampolinePlayer

@onready var loops_label: Label = %LoopsLabel

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	debug()
	if player.position.x > 1100:
		trampoline_player.play()
	if player.position.x > 1150:
		player.position.x = -30
		loops +=1
		loops_label.text = str(loops)


func _on_pause_button_pressed() -> void:
	on_pause_game.emit()

#region Debug

func debug() -> void:
	ImGui.Begin("Gameplay")
	player_speed[0] = player.speed
	ImGui.DragFloat("Player speed", player_speed)
	player.speed = player_speed[0]
	ImGui.End()
	
