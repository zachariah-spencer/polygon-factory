extends Control

@onready var polygon_counter := $PolygonCounter

func _ready() -> void:
	var player := get_tree().get_first_node_in_group('player')
	player.polygons_changed.connect(update_polygons)
	player.polygons_changed.emit(player.polygons)

func update_polygons(polygons):
	polygon_counter.text = 'Polygons - ' + str(polygons)
