extends Structure


@onready var tooltip := $Control/Tooltip
@onready var polygons := $Polygons

var prev_spawned_color : Color

func make_polygon():
	Stats.add_polygon()
	prev_spawned_color = await _spawn_polygon()
	
	var tween = get_tree().create_tween()
	tween.tween_property(visual, 'modulate', prev_spawned_color, 0.1)

func _spawn_polygon() -> Color:
	var polygon_scene = load(polygon_scene_path)
	var polygon_instance = polygon_scene.instantiate()
	
	polygon_instance.global_position = global_position
	polygons.call_deferred("add_child", polygon_instance)
	await polygon_instance.ready
	
	return polygon_instance.initial_color

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed('click'):
		make_polygon()

func _on_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(tooltip, 'modulate', Color(1,1,1,1), 0.15)

func _on_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(tooltip, 'modulate', Color(1,1,1,0), 0.15)
