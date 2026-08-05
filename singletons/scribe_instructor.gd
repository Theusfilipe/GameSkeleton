extends Node

const SAVE_DIRECTORY := "user://saves/"
const TEST_FILE_NAME := "test.json"

var current_load: GameLoad


	

func save_game(save_name : String = "test"):
	# TODO: comentar PESADAMENTE essa função e fazer branches lógicos para
	# lidar com erros e exceções
	
	
	# TODO: resolver whatever this is 
	#var save_file = FileAccess.open("res://saves/"+save_name+".json", FileAccess.WRITE)
	
	# NOTE: Essas linhas são muito úteis para colocar no _ready do autoload de save
	var error = DirAccess.make_dir_absolute(SAVE_DIRECTORY)
	if error != OK:
		print(error)
		match error: 
			ERR_ALREADY_EXISTS:
				pass
			ERR_FILE_CANT_WRITE:
				print("Can't write a file, hard drive is probably full")
			ERR_FILE_CANT_READ:
				print("Can't create a file, probably lacking permission")
			ERR_FILE_ALREADY_IN_USE:
				print("File is opened by another application")

	var save_file = FileAccess.open(SAVE_DIRECTORY + save_name + ".json", FileAccess.WRITE)

	var saveables = get_tree().get_nodes_in_group("saveable")
	for node in saveables:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		# Call the node's save function.
		var node_data = node.call("save")
		
		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)
		save_file.store_line(json_string)
	print("Save complete")

func load_game(path : String = SAVE_DIRECTORY+TEST_FILE_NAME):
	if not FileAccess.file_exists(path):
		print("No save file with such name/path found")
		return # Error! We don't have a save to load.
	
	var save_file = FileAccess.open(path, FileAccess.READ)
	
	if save_file == null:
		print("Unable to open file")
		return ERR_FILE_CANT_READ
	else:
		print("File sucefully opened: "+ str(save_file) +", file length: "+ str(save_file.get_length()))
	current_load = GameLoad.new()
	
	while save_file.get_position() < save_file.get_length():
		print("Reading line: "+ str(save_file.get_position()))
		var json_string = save_file.get_line()
		var json = JSON.new()
		
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return
			
		var node_data = json.data
		print(str(node_data))
		if node_data["object_type"] == "level":
			if not node_data["current_level"] == null:
				current_load.current_level = node_data["current_level"]
				print("Assignment level loaded: " + str(current_load.current_level))
			if not node_data["loops"] == null:
				current_load.loops = node_data["loops"]
				print("Loops quantity loaded: " + str(current_load.loops))
		if node_data["object_type"] == "player":
			if not node_data["player_x"] == null:
				current_load.player_x = node_data["player_x"]
				print("Player position X loaded: " + str(current_load.player_x))
			if not node_data["player_x"] == null:
				current_load.player_y = node_data["player_y"]
				print("Player position loaded: " + str(current_load.player_y))
	
	print("Load complete")
	return current_load
