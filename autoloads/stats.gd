extends Node

signal polygons_changed()

var current_polygons := 5000
var total_polygons := 5000
var polygons_per_minute

func calculate_polygons_per_minute() -> float:
	var ppm : float
	var prev_total_polygons := total_polygons
	
	await get_tree().create_timer(5.0).timeout
	
	ppm = total_polygons - prev_total_polygons
	
	return ppm * 12.0

func add_polygon(num : int = 1):
	current_polygons += num
	total_polygons += num
	polygons_changed.emit()

func subtract_polygon(num : int = 1):
	current_polygons -= num
	polygons_changed.emit()

func _process(_delta: float) -> void:
	polygons_per_minute = await calculate_polygons_per_minute()
