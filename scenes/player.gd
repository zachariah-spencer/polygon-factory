extends CharacterBody2D

@export var speed = 250

enum States {ACTIVE, DISABLED}
var state := States.ACTIVE

func _ready():
	Global.player = self

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target_velocity = input_direction * speed
	if input_direction == Vector2.ZERO:
		velocity = lerp(velocity, target_velocity, 0.35)
	else:
		velocity = lerp(velocity, target_velocity, 0.9)

func _physics_process(_delta):
	if state == States.ACTIVE:
		get_input()
		move_and_slide()
	
