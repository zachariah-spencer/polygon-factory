extends Node2D

@export var triangle_scene_path : String
@onready var tooltip := $Tooltip
@onready var button := $Tooltip/CenterContainer/VBoxContainer/Button
@onready var price_notification_timer := $PriceNotificationTimer

var cost := 50

func _ready():
	tooltip.modulate.a = 0

func spawn_triangle():
	var triangle_scene = load(triangle_scene_path)
	var triangle_instance = triangle_scene.instantiate()
	
	triangle_instance.global_position = global_position
	get_parent().call_deferred("add_child", triangle_instance)
	
	queue_free()

func _on_enter_collision_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(tooltip, 'modulate', Color(1,1,1,1), 0.15)


func _on_exit_collision_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(tooltip, 'modulate', Color(1,1,1,0), 0.15)


func _on_button_pressed() -> void:
	var player = get_tree().get_first_node_in_group('player')
	
	if player.polygons >= cost:
		player.subtract_polygon(cost)
		spawn_triangle()
	else:
		button.text = 'Not Enough Polygons'
		price_notification_timer.start()


func _on_price_notification_timer_timeout() -> void:
	button.text = 'Purchase Triangle'
