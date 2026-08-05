class_name Player
extends Node2D


@export var speed : float = 1.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("flying_bird_animation")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x = position.x + speed


func save():
	var save_dict = {
		"object_type": "player",
		"player_x" : position.x,
		"player_y" : position.y # Vector2 is not supported by JSON
	}
	return save_dict
