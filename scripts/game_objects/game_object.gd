class_name GameObject extends StaticBody2D
# Is inherited by Generator

@export var polygon_scene_path : String
@export var purchased := false

@onready var visual := $Visual

var generator : Generator = null

func _ready():
	visual.modulate.a = 0
	
	if purchased:
		_reload()
	else:
		_load()

func _reload():
	visual.modulate.a = 1

func _load():
	var tween = get_tree().create_tween()
	tween.tween_property(visual, 'modulate', Color(1,1,1,1), 0.5)
