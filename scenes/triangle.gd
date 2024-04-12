extends StaticBody2D

@export var polygon_scene_path : String

@onready var visual := $Visual
@onready var polygons := $Polygons
@onready var pulse := $Pulse

var generator : Generator

func _ready():
	generator.polygons_generated.connect(make_polygon)
	visual.modulate.a = 0
	rotation = randf_range(0, 360)
	var tween = get_tree().create_tween()
	tween.tween_property(visual, 'modulate', Color(1,1,1,1), 0.5)

func make_polygon(_polygon_count : int):
	var polygon_scene = load(polygon_scene_path)
	var polygon_instance = polygon_scene.instantiate()
	
	polygon_instance.global_position = global_position
	polygons.add_child(polygon_instance)
	
	await polygon_instance.ready
	visual.modulate = polygon_instance.initial_color

func _physics_process(_delta: float) -> void:
	rotation += 0.02
