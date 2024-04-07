extends CharacterBody2D

signal polygons_changed(polygons :  int)
@export var speed = 400

var polygons := 0

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target_velocity = input_direction * speed
	if input_direction == Vector2.ZERO:
		velocity = lerp(velocity, target_velocity, 0.35)
	else:
		velocity = lerp(velocity, target_velocity, 0.9)

func add_polygon(num : int = 1):
	polygons += num
	polygons_changed.emit(polygons)

func subtract_polygon(num : int = 1):
	polygons -= num
	polygons_changed.emit(polygons)

func _physics_process(_delta):
	get_input()
	move_and_slide()
