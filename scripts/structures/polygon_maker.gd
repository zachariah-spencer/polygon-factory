extends Structure


@onready var tooltip := $Control/Tooltip
@onready var polygons := $Polygons
@onready var polygons_component := $PolygonsComponent

var prev_spawned_color : Color

func make_polygon():
	Stats.add_polygon()
	prev_spawned_color = await polygons_component.spawn_polygon()
	
	var tween = get_tree().create_tween()
	tween.tween_property(visual, 'modulate', prev_spawned_color, 0.1)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed('click'):
		make_polygon()

func _on_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(tooltip, 'modulate', Color(1,1,1,1), 0.15)

func _on_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(tooltip, 'modulate', Color(1,1,1,0), 0.15)
