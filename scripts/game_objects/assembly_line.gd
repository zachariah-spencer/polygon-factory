extends GameObject

@onready var polygon := $Polygon
@onready var polygon_2 := $Polygon2
@onready var move_polygon := $MovePolygon

func activate_upgrade_1():
	generator.max_cooldown *= 0.5
	
	polygon_2.visible = true
	move_polygon.play('move_two_polygons')
	
	generator.upgrade_1_active = true

func _reload():
	super._reload()
	
	if generator.upgrade_1_active:
		polygon_2.visible = true
		move_polygon.play('move_two_polygons')

func _randomize_polygon(num):
	match num:
		1:
			polygon.self_modulate = Global.get_random_color()
			polygon.rotation_degrees = randf_range(-360.0, 360.0)
		2:
			polygon_2.self_modulate = Global.get_random_color()
			polygon_2.rotation_degrees = randf_range(-360.0, 360.0)


func _on_mouse_entered() -> void:
	if not upgrades_menu_active:
		_spawn_upgrades_menu()
