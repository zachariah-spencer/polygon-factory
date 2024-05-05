extends Node

signal game_loaded
signal structure_hovered
signal booster_room_entered

enum Directions {LEFT, RIGHT, UP, DOWN, NULL = -1}

var game_world
var background_objects
var player

var colors = [
	Color.DARK_RED,
	Color.BLUE_VIOLET,
	Color.YELLOW,
	Color.SEA_GREEN,
	Color.AQUAMARINE,
	Color.CRIMSON,
	Color.DARK_ORANGE,
	Color.LIGHT_GREEN,
	Color.MIDNIGHT_BLUE,
	Color.POWDER_BLUE,
	Color.TOMATO,
	Color.KHAKI
]

func announce_game_loaded():
	game_loaded.emit()

func play_structures_tutorial():
	structure_hovered.emit()

func play_booster_tutorial():
	booster_room_entered.emit()

func get_random_color() -> Color:
	return colors[randi_range(0,(Global.colors.size() - 1))]

func register_game_world(in_game_world):
	game_world = in_game_world

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug_save'):
		save_game()

# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game():
	print('SAVING GAME')
	@warning_ignore('shadowed_variable')
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persistent")
	for node in save_nodes:
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

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(json_string)

#func register_background_objects(in_background_objects):
	#background_objects = in_background_objects
