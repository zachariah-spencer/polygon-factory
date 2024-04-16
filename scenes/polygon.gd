extends RigidBody2D

var initial_velocity : Vector2
var initial_torque : float
var initial_scale : float
var initial_color
var final_color

@onready var visual := $Visual

func _ready() -> void:
	initial_velocity = Vector2(randf_range(-100,100), randf_range(-200, -400))
	initial_torque = randf_range(-48, 48)
	initial_scale = randf_range(0.6,1.75)
	initial_color = Global.get_random_color()
	final_color = initial_color
	final_color.a = 0
	
	apply_central_impulse(initial_velocity)
	apply_torque_impulse(initial_torque)
	visual.scale = Vector2(initial_scale, initial_scale)
	visual.modulate = initial_color
	
	
	var tween = get_tree().create_tween()
	tween.tween_property(visual, 'modulate', final_color, 0.5)
	tween.tween_callback(queue_free)
