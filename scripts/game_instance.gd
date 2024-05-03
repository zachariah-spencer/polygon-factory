extends Node2D

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
	#TODO: SAVE/LOAD which tutorials have been played out already
	#TODO: SAVE/LOAD room the player is in and current player position
	
	Stats.current_polygons = node_data['polygons']
	Stats.total_polygons = node_data['total_polygons']
	Stats.upgrade_tier = node_data['upgrade_tier']
	Stats.polygons_per_minute = node_data['polygons_per_minute']
	Stats.polygons_changed.emit()
	
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
	
	
	Global.player.upgrade_level = Stats.upgrade_tier
	Global.player.upgrade(Global.player.upgrade_level)
