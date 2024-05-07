extends Control

@onready var polygon_counter := $PolygonCounter
@onready var pause_menu_background := $PauseMenu/Background
@onready var pause_menu := $PauseMenu
var pause_menu_active := false


func _input(_event):
	if Input.is_action_just_pressed('pause'):
		pause_menu_active = not pause_menu_active
		_set_pause(pause_menu_active)

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
	var main_menu = get_tree().get_first_node_in_group('MainMenu')
	Global.save_game()
	
	main_menu.open()
	get_parent().get_parent().queue_free()


func _on_quit_game_pressed():
	Global.save_game()
	get_tree().quit()
