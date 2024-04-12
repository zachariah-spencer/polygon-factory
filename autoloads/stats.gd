extends Node

signal polygons_changed()

var current_polygons := 250

func add_polygon(num : int = 1):
	current_polygons += num
	polygons_changed.emit()

func subtract_polygon(num : int = 1):
	current_polygons -= num
	polygons_changed.emit()
