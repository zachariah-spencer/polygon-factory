extends Structure

@onready var polygon := $Polygon
@onready var polygon_2 := $Polygon2
@onready var move_polygon := $MovePolygon
@onready var sound := $GeneratorSoundManager
@onready var ui_sound := $UIAudioManager

func activate_upgrade(num : int):
	match(num):
		1:
			virtual_structure.max_cooldown *= 0.5
			
			polygon_2.visible = true
			move_polygon.play('move_two_polygons')
			
			virtual_structure.upgrade_1_active = true

func _load():
	super._load()
	ui_sound.play_tone_1()

func _reload():
	super._reload()
	
	if virtual_structure.upgrade_1_active:
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
