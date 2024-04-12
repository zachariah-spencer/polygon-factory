extends StaticBody2D

const OBJECT_ID := 'polygon_maker'
@export var polygon_scene_path : String


@onready var tooltip := $Control/Tooltip
@onready var polygons := $Polygons
@onready var visual := $Visual

func make_polygon():
	var polygon_scene = load(polygon_scene_path)
	var polygon_instance = polygon_scene.instantiate()
	
	polygon_instance.global_position = global_position
	polygons.call_deferred("add_child", polygon_instance)
	
	Stats.add_polygon()
	
	await polygon_instance.ready
	var tween = get_tree().create_tween()
	tween.tween_property(visual, 'modulate', polygon_instance.initial_color, 0.1)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed('click'):
		make_polygon()


func _on_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(tooltip, 'modulate', Color(1,1,1,1), 0.15)
	
	


func _on_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(tooltip, 'modulate', Color(1,1,1,0), 0.15)
