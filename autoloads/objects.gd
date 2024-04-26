extends Node

var game_objects := {}

func get_object(object_id : String, is_generator := false, polygons := 1):
	if not game_objects.has(object_id):
		
		var game_object
		
		if is_generator:
			game_object = VirtualStructure.new()
			game_object.polygons_increment = polygons
		else:
			game_object = GameObject.new()
		
		game_objects[object_id] = game_object
		
		if game_object is VirtualStructure:
			game_object.polygons_generated.connect(Stats.add_polygon)
		
	return game_objects[object_id]

func has_object(object_id : String) -> bool:
	return game_objects.has(object_id)

func clear_objects():
	game_objects.clear()

func get_generators():
	var generators = {}
	
	for object_id in game_objects:
		if game_objects[object_id] is VirtualStructure:
			generators[object_id] = game_objects[object_id]
	
	return generators

func _process(delta : float):
	for object_id in game_objects:
		if game_objects[object_id] is VirtualStructure:
			game_objects[object_id].reduce_cooldown_by(delta)
