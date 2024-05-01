extends Control

@onready var transition_screen := $TransitionScreen
@onready var background := $Background
@onready var settings_list := $SettingsList
@onready var root := $Root
@onready var title := $Title
var game_world : String = 'res://scenes/game_instance.tscn'
var current_window : Control

func _ready():
	transition_screen.visible = true
	var tween_out = get_tree().create_tween()
	tween_out.tween_property(transition_screen, 'modulate', Color.TRANSPARENT, 0.5)

func _process(delta: float) -> void:
	background.color.h += sin(delta) * 0.1

func _start_new_game():
	var tween_in = get_tree().create_tween()
	tween_in.tween_property(transition_screen, 'modulate', Color.WHITE, 0.5)
	
	await tween_in.finished
	var game_world_instance = load(game_world).instantiate()
	get_parent().add_child(game_world_instance)
	
	var tween_out = get_tree().create_tween()
	tween_out.tween_property(transition_screen, 'modulate', Color.TRANSPARENT, 0.5)
	tween_out.tween_callback(queue_free)

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		_start_new_game()
		return

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	var node_data
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		node_data = json.get_data()
	
	var tween_in = get_tree().create_tween()
	tween_in.tween_property(transition_screen, 'modulate', Color.WHITE, 0.5)
	
	await tween_in.finished
	root.visible = false
	background.visible = false
	title.visible = false
	
	
	# Firstly, we need to create the object and add it to the tree and set its position.
	var new_object = load(node_data["filename"]).instantiate()
	get_node(node_data["parent"]).add_child(new_object)
	new_object.load(node_data)
	
	
	var tween_out = get_tree().create_tween()
	tween_out.tween_property(transition_screen, 'modulate', Color.TRANSPARENT, 0.5)
	tween_out.tween_callback(queue_free)
	

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	current_window.visible = false
	current_window = root
	root.visible = true

func _on_play_pressed() -> void:
	load_game()
