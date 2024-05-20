extends Control


@onready var polygon_counter := $PolygonCounter
@onready var pause_menu_background := $PauseMenu/Background
@onready var pause_menu := $PauseMenu

@onready var menu = preload('res://scenes/main_menu.tscn')
@onready var trans_screen := preload('res://scenes/transition_screen.tscn')
var pause_menu_active := false

func toggle_pause():
	pause_menu_active = not pause_menu_active
	_set_pause(pause_menu_active)

func _input(_event):
	if Global.player.state != Global.player.States.DISABLED:
		if Input.is_action_just_pressed('pause'):
			toggle_pause()

func _ready() -> void:
	pause_menu.modulate = Color.TRANSPARENT
	Stats.polygons_changed.connect(update_polygons)
	update_polygons()

func _process(delta: float) -> void:
	pause_menu_background.color.h += sin(delta) * 0.1

func update_polygons():
	polygon_counter.text = 'Polygons - ' + str(Stats.current_polygons)

func _set_pause(paused : bool):
	var tween = create_tween()
	
	get_tree().paused = paused
	
	for control in pause_menu.get_node('CenterContainer/Buttons').get_children():
		control.mouse_filter = MOUSE_FILTER_PASS if paused else MOUSE_FILTER_IGNORE
	tween.tween_property(pause_menu, 'modulate', Color.WHITE if paused else Color.TRANSPARENT, 0.5)


func _on_resume_pressed():
	pause_menu_active = false
	_set_pause(pause_menu_active)


func _on_main_menu_pressed():
	Global.save_game()
	
	
	var menu_inst = menu.instantiate()
	var trans_screen_inst = trans_screen.instantiate()
	menu_inst.is_first_launch = false
	
	add_child(trans_screen_inst)
	
	trans_screen_inst.fade_in()
	
	pause_menu_active = false
	get_tree().paused = pause_menu_active
	
	get_tree().get_first_node_in_group('Main').add_child(menu_inst)


func _on_quit_game_pressed():
	Global.save_game()
	get_tree().quit()
