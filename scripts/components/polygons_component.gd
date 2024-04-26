class_name PolygonsComponent extends Node2D

var polygon_scene_path := 'res://scenes/polygon.tscn'

@onready var polygons := $Polygons

func spawn_polygon() -> Color:
	var polygon_scene = load(polygon_scene_path)
	var new_triangle_color := Color.WHITE
	var polygon_instance = polygon_scene.instantiate()
	
	polygon_instance.global_position = global_position
	polygons.add_child(polygon_instance)
	new_triangle_color = polygon_instance.initial_color
	
	return new_triangle_color
