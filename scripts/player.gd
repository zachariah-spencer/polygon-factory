extends CharacterBody2D

signal exiting_cockpit(player : Node2D)

@export var speed = 250

@onready var power_vacuum_fx := $PowerVacuum

enum States {ACTIVE, DISABLED, PILOTING}
var state := States.ACTIVE
var upgrade_level := 0

func _ready():
	Global.player = self


func get_input():
	if state == States.ACTIVE:
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
	elif state == States.PILOTING:
		if Input.is_action_just_pressed('exit_cockpit'):
			exiting_cockpit.emit(self)

func _physics_process(_delta):
	if state != States.DISABLED:
		get_input()
		move_and_slide()
	elif state == States.DISABLED:
		velocity = Vector2.ZERO
		move_and_slide()

func change_state(new_state : States):
	state = new_state
	
	if new_state == States.DISABLED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func upgrade(new_upgrade_tier : int):
	upgrade_level = new_upgrade_tier
	
	match new_upgrade_tier:
		1:
			speed += 150
		2:
			speed += 150
		3:
			speed += 150
