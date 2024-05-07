class_name GameInstance extends Node2D

@onready var tutorials_ui := $StaticLayer/UI/TutorialsUI
@onready var game_world := $GameWorld
var starting_room_path := 'res://scenes/rooms/room_1.tscn'

func new_game():
	var starting_room : Node2D = load(starting_room_path).instantiate()
	game_world.set_initial_room(starting_room)

func save():
	var save_dict = {
		'filename' : get_scene_file_path(),
		'parent' : get_parent().get_path(),
		'pos_x' : position.x,
		'pos_y' : position.y,
		'polygons' : Stats.current_polygons,
		'total_polygons' : Stats.total_polygons,
		'upgrade_tier' : Stats.upgrade_tier,
		'polygons_per_minute' : Stats.polygons_per_minute,
		'intros_played' : tutorials_ui.get_message_block_played(tutorials_ui.intros),
		'structures_played' : tutorials_ui.get_message_block_played(tutorials_ui.structures),
		'boosters_played' : tutorials_ui.get_message_block_played(tutorials_ui.boosters),
		'player_pos_x' : Global.player.global_position.x,
		'player_pos_y' : Global.player.global_position.y,
		'current_room_filename' : get_tree().get_first_node_in_group('Room').get_scene_file_path()
	}
	
	for id in Structures.virtual_structures:
		var generator = Structures.virtual_structures[id]
		
		var generator_dict = {
			'creates_polygons' : generator.creates_polygons,
			'max_cooldown' : generator.max_cooldown,
			'polygons_increment' : generator.polygons_increment,
			'upgrade_1_active' : generator.upgrade_1_active,
			'upgrade_2_active' : generator.upgrade_2_active,
			'upgrade_3_active' : generator.upgrade_3_active,
			'polygons_boost' : generator.polygons_boost
		}
		save_dict[id] = generator_dict
	
	return save_dict

func load(node_data : Dictionary):
	Stats.current_polygons = node_data['polygons']
	Stats.total_polygons = node_data['total_polygons']
	Stats.upgrade_tier = node_data['upgrade_tier']
	Stats.polygons_per_minute = node_data['polygons_per_minute']
	Stats.polygons_changed.emit()
	
	tutorials_ui.set_message_block_played(tutorials_ui.intros, node_data['intros_played'])
	tutorials_ui.set_message_block_played(tutorials_ui.structures, node_data['structures_played'])
	tutorials_ui.set_message_block_played(tutorials_ui.boosters, node_data['boosters_played'])
	
	for save_data_key in node_data.keys():
		if node_data[save_data_key] is Dictionary:
			var generator_dictionary = node_data[save_data_key]
			
			var id = save_data_key
			var is_generator = generator_dictionary['creates_polygons']
			var increment = generator_dictionary['polygons_increment']
			var cd = generator_dictionary['max_cooldown']
			
			var virtual_structure = Structures.register_virtual_structure(id, is_generator, increment, cd)
			
			virtual_structure.upgrade_1_active = generator_dictionary['upgrade_1_active']
			virtual_structure.upgrade_2_active = generator_dictionary['upgrade_2_active']
			virtual_structure.upgrade_3_active = generator_dictionary['upgrade_3_active']
			virtual_structure.polygons_boost = generator_dictionary['polygons_boost']
			virtual_structure.randomize_timing()
	
	for spawner in get_tree().get_nodes_in_group('Spawner'):
		spawner._verify_purchased_state()
	
	var current_room = load(node_data['current_room_filename']).instantiate()
	game_world.set_initial_room(current_room)
	
	
	Global.player.upgrade_level = Stats.upgrade_tier
	Global.player.upgrade(Global.player.upgrade_level)
	Global.player.global_position = Vector2(node_data['player_pos_x'], node_data['player_pos_y'])
	Global.announce_game_loaded()


func _on_autosave_timer_timeout():
	Global.save_game()
