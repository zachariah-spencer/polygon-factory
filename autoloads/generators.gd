extends Node

var generators := {}

func get_generator(generator_id : String) -> Generator:
	
	if not generators.has(generator_id):
		var generator = Generator.new()
		generators[generator_id] = generator
		generator.polygons_generated.connect(Stats.add_polygon)
	
	return generators[generator_id]

func has_generator(generator_id : String) -> bool:
	return generators.has(generator_id)

func clear_generators():
	generators.clear()

func _process(delta : float):
	for generator_id in generators:
		generators[generator_id].reduce_cooldown_by(delta)
