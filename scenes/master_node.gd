extends Node

@export_file("*.tscn") var main_menu_scene_path : String = "res://scenes/main_menu_scene.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_scene(main_menu_scene_path)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _load_scene(path : String) -> void:
	var next_scene : Node = load(path).instantiate()
	if get_child_count() == 0:
		add_child(next_scene)
	else:
		var current_scene = get_child(0)
		add_child(next_scene)
		current_scene.queue_free()
	
	pass
