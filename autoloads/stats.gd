extends Node

signal polygons_changed()

var current_polygons := 250
var total_polygons := 250

func get_polygons_per_minute() -> float:
	return float(Generators.generators.size()) * 60.0

func add_polygon(num : int = 1):
	current_polygons += num
	total_polygons += num
	polygons_changed.emit()

func subtract_polygon(num : int = 1):
	current_polygons -= num
	polygons_changed.emit()
