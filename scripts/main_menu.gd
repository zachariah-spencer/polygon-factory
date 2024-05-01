extends Control

@onready var transition_screen := $TransitionScreen
@onready var background := $Background
@onready var saves_list := $SavesList
@onready var root := $Root
var game_world : String = 'res://scenes/game_instance.tscn'
var current_window : Control

func _ready():
	transition_screen.visible = true
	var tween_out = get_tree().create_tween()
	tween_out.tween_property(transition_screen, 'modulate', Color.TRANSPARENT, 0.5)

func _process(delta: float) -> void:
	background.color.h += sin(delta) * 0.1

func _start_new_game():
	var tween_in = get_tree().create_tween()
	tween_in.tween_property(transition_screen, 'modulate', Color.WHITE, 0.5)
	
	await tween_in.finished
	var game_world_instance = load(game_world).instantiate()
	get_parent().add_child(game_world_instance)
	
	var tween_out = get_tree().create_tween()
	tween_out.tween_property(transition_screen, 'modulate', Color.TRANSPARENT, 0.5)
	tween_out.tween_callback(queue_free)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	current_window.visible = false
	current_window = root
	root.visible = true

func _on_play_pressed() -> void:
	current_window = saves_list
	saves_list.visible = true
	root.visible = false
	#_start_new_game()
