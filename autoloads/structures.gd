extends Node

var virtual_structures := {}

func register_virtual_structure(id : String, creates_polygons := false, polygons := 1):
	if not virtual_structures.has(id):
		var virtual_structure
		virtual_structure = VirtualStructure.new()
		
		if creates_polygons:
			virtual_structure.creates_polygons = creates_polygons
			virtual_structure.polygons_increment = polygons
			virtual_structure.polygons_generated.connect(Stats.add_polygon)
		virtual_structures[id] = virtual_structure
		
	return virtual_structures[id]

func has_virtual_structure(id : String) -> bool:
	return virtual_structures.has(id)

func clear_virtual_structures():
	virtual_structures.clear()

func get_virtual_structures():
	var generators = {}
	
	for id in virtual_structures:
		if virtual_structures[id].creates_polygons:
			generators[id] = virtual_structures[id]
	
	return generators

func _process(delta : float):
	for id in virtual_structures:
		if virtual_structures[id].creates_polygons:
			virtual_structures[id].reduce_cooldown_by(delta)
