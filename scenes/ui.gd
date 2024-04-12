extends Control

@onready var polygon_counter := $PolygonCounter

func _ready() -> void:
	Stats.polygons_changed.connect(update_polygons)
	update_polygons()

func update_polygons():
	polygon_counter.text = 'Polygons - ' + str(Stats.current_polygons)
