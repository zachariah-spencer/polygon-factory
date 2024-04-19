extends Control


@onready var total_polygons_counter := $CenterContainer/VBoxContainer/TotalPolygonsCounter
@onready var polygons_per_minute_counter := $CenterContainer/VBoxContainer/PolygonsPerMinuteCounter

func _process(_delta: float) -> void:
	total_polygons_counter.text = str(Stats.total_polygons)
	polygons_per_minute_counter.text = str(Stats.polygons_per_minute)
