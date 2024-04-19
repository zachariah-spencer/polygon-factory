extends GameObject

@onready var polygon := $Polygon
@onready var move_polygon := $MovePolygon

func _randomize_polygon():
	polygon.self_modulate = Global.get_random_color()
	polygon.rotation_degrees = randf_range(-360.0, 360.0)
	var rand_float := randf_range(0.2,0.5)
	var rand_scale := Vector2(rand_float, rand_float)
	var anim = move_polygon.get_animation("move_polygon")
