class_name GameObject extends StaticBody2D
# Is inherited by Generator

@export var polygon_scene_path : String
@export var purchased := false

@export var upgrade_1_info := [false, 'Title', 'Description', 0]

@export var upgrade_2_info := [false, 'Title', 'Description', 0]

@export var upgrade_3_info := [false, 'Title', 'Description', 0]


@onready var visual := $Visual
@onready var no_rotate := $NoRotate

var upgrades_menu_scene_path := 'res://scenes/upgrades_menu.tscn'
var upgrades_menu_active := false
var generator : Generator = null

func activate_upgrade_1():
	pass

func activate_upgrade_2():
	pass

func activate_upgrade_3():
	pass

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


func _spawn_upgrades_menu():
	var upgrades_menu_scene := load(upgrades_menu_scene_path)
	var upgrades_menu_instance = upgrades_menu_scene.instantiate()
	
	
	no_rotate.add_child(upgrades_menu_instance)
	
	upgrades_menu_instance.global_position = global_position - Vector2((256.0 / 2.0), (128.0 / 2.0))
	upgrades_menu_instance.upgrades_menu_exited.connect(_despawn_upgrades_menu)
	upgrades_menu_instance.load_menu_options(upgrade_1_info, upgrade_2_info, upgrade_3_info)
	upgrades_menu_active = true
	
	if upgrade_1_info[0]:
		upgrades_menu_instance.upgrade_1_purchased.connect(activate_upgrade_1)
	
	if upgrade_2_info[0]:
		upgrades_menu_instance.upgrade_2_purchased.connect(activate_upgrade_2)
	
	upgrades_menu_instance.validate_purchased_upgrades(generator.upgrade_1_active, generator.upgrade_2_active, generator.upgrade_3_active)
	
func _despawn_upgrades_menu():
	upgrades_menu_active = false
