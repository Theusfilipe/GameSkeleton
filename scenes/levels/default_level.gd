class_name DefaultLevelScene
extends Node

@onready var player: Player = %Player

@export var speed : float = 1.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player.position.x = player.position.x + speed
	pass
