class_name UpgradesComponent extends Node2D

signal upgrade_purchased(num : int)

@export var upgrade_1_info := [false, 'Title', 'Description', 0]
@export var upgrade_2_info := [false, 'Title', 'Description', 0]
@export var upgrade_3_info := [false, 'Title', 'Description', 0]

@onready var menu := $NoRotate/Menu
@onready var no_rotate := $NoRotate
@onready var exit_area := $NoRotate/ExitArea

var upgrades_purchased := {1: false, 2: false, 3: false}
var menu_scene_path := 'res://scenes/upgrades_menu.tscn'
var active := false

#TODO: Refactor validating purchased upgrades on _reload() of object

func purchase_upgrade(num : int):
	upgrade_purchased.emit(num)

func _ready():
	menu.update_purchased_upgrades(upgrades_purchased)
	menu.load_menu_options(upgrade_1_info, upgrade_2_info, upgrade_3_info)
	
	_set_menu_position()
	_hide_menu()
	
	get_parent().mouse_entered.connect(_show_menu)

func _show_menu():
	menu.process_mode = Node.PROCESS_MODE_INHERIT
	menu.visible = true
	active = true

func _hide_menu():
	menu.process_mode = Node.PROCESS_MODE_DISABLED
	menu.visible = false
	active = false

func _set_menu_position():
	var offset = Vector2(menu.size.x / 2.0, menu.size.y /  2.0)
	menu.global_position = global_position - offset
	exit_area.global_position = global_position
	
#func _spawn_menu():
	#if upgrade_1_info[0]:
		#upgrades_menu_instance.upgrade_1_purchased.connect(activate_upgrade_1)
	#
	#if upgrade_2_info[0]:
		#upgrades_menu_instance.upgrade_2_purchased.connect(activate_upgrade_2)
	
	#upgrades_menu_instance.validate_purchased_upgrades(generator.upgrade_1_active, generator.upgrade_2_active, generator.upgrade_3_active)
