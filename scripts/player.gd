extends CharacterBody2D



@export var speed = 250

@onready var power_vacuum_fx := $PowerVacuum

enum States {ACTIVE, DISABLED}
var state := States.ACTIVE
var upgrade_level := 0

func _ready():
	Global.player = self

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target_velocity = input_direction * speed
	if input_direction == Vector2.ZERO:
		velocity = lerp(velocity, target_velocity, 0.35)
		
		if upgrade_level >= 1:
			power_vacuum_fx.emitting = false
	else:
		velocity = lerp(velocity, target_velocity, 0.9)
		
		if upgrade_level >= 1:
			power_vacuum_fx.emitting = true

func _physics_process(_delta):
	if state == States.ACTIVE:
		get_input()
		move_and_slide()

func upgrade(new_upgrade_tier : int):
	
	upgrade_level = new_upgrade_tier
	print(upgrade_level)
	
	match new_upgrade_tier:
		1:
			speed += 150
		2:
			speed += 150
		3:
			speed += 150
