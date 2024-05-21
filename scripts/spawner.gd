extends Node2D

signal object_spawning_started

@export var spawnable_scene_path : String
@export var spawnable_name := 'Spawnable Name'
@export var spawnable_description := 'Spawnable Description'
@export var cost := 0
@export var spawnable_rotation_degrees := 0.0
@export var triggers_tutorial := true

@onready var tooltip := $Tooltip
@onready var tooltip_title := $Tooltip/CenterContainer/VBoxContainer/Title
@onready var tooltip_description := $Tooltip/CenterContainer/VBoxContainer/Description
@onready var button := $Tooltip/CenterContainer/VBoxContainer/Button
@onready var price_notification_timer := $PriceNotificationTimer
@onready var ui_audio_manager := $UIAudioManager

func _ready():
	_verify_purchased_state()
	_initialize_tooltip()

func spawn_object(purchased := false):
	var spawnable_scene = load(spawnable_scene_path)
	var spawnable_instance = spawnable_scene.instantiate()
	
	spawnable_instance.id = _get_unique_id()
	spawnable_instance.purchased = purchased
	spawnable_instance.global_position = global_position
	spawnable_instance.rotation_degrees = spawnable_rotation_degrees
	
	get_parent().add_child(spawnable_instance)
	object_spawning_started.emit()
	
	queue_free()

func _verify_purchased_state():
	if Structures.has_virtual_structure(_get_unique_id()):
		spawn_object.call_deferred(true)

func _initialize_tooltip():
	tooltip.modulate.a = 0
	tooltip_title.text = spawnable_name
	tooltip_description.text = spawnable_description + '\n Cost - ' + str(cost) + " Polygons"
	button.text = 'Purchase ' + spawnable_name

func _get_unique_id() -> String:
	return get_parent().name + '/' + name

func _on_enter_collision_mouse_entered() -> void:
	ui_audio_manager.play_click()
	if triggers_tutorial:
		Global.play_structures_tutorial()
	
	button.disabled = false
	
	var tween = get_tree().create_tween()
	tween.tween_property(tooltip, 'modulate', Color(1,1,1,1), 0.15)

func _on_exit_collision_mouse_exited() -> void:
	button.disabled = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(tooltip, 'modulate', Color(1,1,1,0), 0.15)

func _on_button_pressed() -> void:
	
	if Stats.current_polygons >= cost:
		Stats.subtract_polygon(cost)
		spawn_object()
	else:
		ui_audio_manager.play_tone_2()
		button.text = 'Not Enough Polygons'
		price_notification_timer.start()

func _on_price_notification_timer_timeout() -> void:
	button.text = 'Purchase ' + spawnable_name
