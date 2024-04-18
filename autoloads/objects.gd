extends Node

var game_objects := {}

func get_object(object_id : String, is_generator := false):
	if not game_objects.has(object_id):
		
		var game_object
		
		if is_generator:
			game_object = Generator.new()
		else:
			game_object = GameObject.new()
		
		game_objects[object_id] = game_object
		
		if game_object is Generator:
			game_object.polygons_generated.connect(Stats.add_polygon)
		
	return game_objects[object_id]

func has_object(object_id : String) -> bool:
	return game_objects.has(object_id)

func clear_objects():
	game_objects.clear()

func get_generators():
	var generators = {}
	
	for object_id in game_objects:
		if game_objects[object_id] is Generator:
			generators[object_id] = game_objects[object_id]
	
	return generators

func _process(delta : float):
	for object_id in game_objects:
		if game_objects[object_id] is Generator:
			game_objects[object_id].reduce_cooldown_by(delta)

#func get_generator(generator_id : String) -> Generator:
	#
	#if not generators.has(generator_id):
		#var generator = Generator.new()
		#generators[generator_id] = generator
		#generator.polygons_generated.connect(Stats.add_polygon)
	#
	#return generators[generator_id]
#
#func has_generator(generator_id : String) -> bool:
	#return generators.has(generator_id)
#
#func clear_generators():
	#generators.clear()
