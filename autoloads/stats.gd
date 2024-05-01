extends Node

signal polygons_changed()

var current_polygons := 100000
var total_polygons := 100000
var upgrade_tier := 0
var polygons_per_minute := 0.0

func calculate_polygons_per_minute() -> float:
	var ppm : float
	var prev_total_polygons := float(total_polygons)
	
	await get_tree().create_timer(5.0).timeout
	
	ppm = float(total_polygons) - prev_total_polygons
	
	polygons_per_minute = ppm
	
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
