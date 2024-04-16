extends StaticBody2D

@export var polygon_scene_path : String

@onready var visual := $Visual
@onready var polygons := $Polygons
@onready var pulse := $Pulse

var generator : Generator
var purchased := false
var previous_color := Color.WHITE

func _ready():
	generator.polygons_generated.connect(make_polygon)
	visual.modulate.a = 0
	rotation = randf_range(0, 360)
	
	if purchased:
		_reload()
	else:
		_load()

func _reload():
	pulse.preprocess = (generator.max_cooldown - generator.cooldown)
	pulse.restart()
	pulse.emitting = true
	visual.modulate = Global.get_random_color()

func _load():
	var tween = get_tree().create_tween()
	tween.tween_property(visual, 'modulate', Color(1,1,1,1), 0.5)

func make_polygon(_polygon_count : int):
	pulse.preprocess = 0.0
	pulse.restart()
	pulse.emitting = true
	var polygon_scene = load(polygon_scene_path)
	var polygon_instance = polygon_scene.instantiate()
	
	polygon_instance.global_position = global_position
	polygons.add_child(polygon_instance)
	
	var previous_color = polygon_instance.initial_color
	
	var tween = get_tree().create_tween()
	tween.tween_property(visual, 'modulate', previous_color, 0.2)

func _physics_process(_delta: float) -> void:
	rotation += 0.02
