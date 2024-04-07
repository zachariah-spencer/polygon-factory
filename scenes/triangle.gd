extends StaticBody2D

const OBJECT_ID := 'triangle'
@export var polygon_scene_path : String

@onready var visual := $Visual
@onready var polygons := $Polygons
@onready var pulse := $Pulse

func _ready():
	visual.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property(visual, 'modulate', Color(1,1,1,1), 0.5)

func make_polygon():
	var polygon_scene = load(polygon_scene_path)
	var polygon_instance = polygon_scene.instantiate()
	
	polygon_instance.global_position = global_position
	polygons.call_deferred("add_child", polygon_instance)
	
	var player = get_tree().get_first_node_in_group('player')
	player.add_polygon()
	
	await polygon_instance.ready
	visual.modulate = polygon_instance.initial_color

func _physics_process(delta: float) -> void:
	rotation += 0.02


func _on_timer_timeout() -> void:
	make_polygon()
