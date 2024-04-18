extends Node2D

signal room_exited(old_room : Node2D, new_room : Node2D, exit_direction : int)

@export var exit_left_scene_path : String
@export var exit_right_scene_path : String
@export var exit_up_scene_path : String
@export var exit_down_scene_path : String

@export var camera_following_x := false
@export var camera_following_y := false

@onready var exit_left := $ExitLeft
@onready var exit_right := $ExitRight
@onready var exit_up := $ExitUp
@onready var exit_down := $ExitDown

@onready var exits = [exit_left,exit_right,exit_up,exit_down]
@onready var view := $View

var player_spawn_position : Vector2
var entrance_offset := 50


func _ready():
	await get_tree().create_timer(0.001).timeout
	load_room()
	

func insert_player(player : CharacterBody2D, entered_from : int):
	match(entered_from):
		Global.Directions.LEFT:
			player_spawn_position = exit_right.global_position + Vector2(-entrance_offset, 0)
		Global.Directions.RIGHT:
			player_spawn_position = exit_left.global_position + Vector2(entrance_offset, 0)
		Global.Directions.UP:
			player_spawn_position = exit_down.global_position + Vector2(0, -entrance_offset)
		Global.Directions.DOWN:
			player_spawn_position = exit_up.global_position + Vector2(0, entrance_offset)
	
	Global.player.global_position = player_spawn_position

func exit_room(exit_direction : int):
	match(exit_direction):
		Global.Directions.LEFT:
			room_exited.emit(self, _instantiate_room_scene(exit_left_scene_path), Global.Directions.LEFT)
		Global.Directions.RIGHT:
			room_exited.emit(self, _instantiate_room_scene(exit_right_scene_path), Global.Directions.RIGHT)
		Global.Directions.UP:
			room_exited.emit(self, _instantiate_room_scene(exit_up_scene_path), Global.Directions.UP)
		Global.Directions.DOWN:
			room_exited.emit(self, _instantiate_room_scene(exit_down_scene_path), Global.Directions.DOWN)

func load_room():
	
	for exit in exits:
			exit.monitoring = true
	
	if exit_left_scene_path == '':
		exit_left.monitoring = false
	if exit_right_scene_path == '':
		exit_right.monitoring = false
	if exit_up_scene_path == '':
		exit_up.monitoring = false
	if exit_down_scene_path == '':
		exit_down.monitoring = false
	
	

func deload_room():
	for exit in exits:
		exit.set_deferred('monitoring', false)
	queue_free()

func _physics_process(_delta: float) -> void:
	if camera_following_x:
		view.global_position.x = Global.player.global_position.x
	if camera_following_y:
		view.global_position.y = Global.player.global_position.y

func _instantiate_room_scene(room_scene_path : String):
	var room_scene = load(room_scene_path)
	var instance : Node2D
	
	instance = room_scene.instantiate()
	
	return instance

func _on_exit_left_body_entered(_player : PhysicsBody2D):
	
	exit_room(Global.Directions.LEFT)


func _on_exit_right_body_entered(_player : PhysicsBody2D):
	exit_room(Global.Directions.RIGHT)


func _on_exit_up_body_entered(_player : PhysicsBody2D):
	exit_room(Global.Directions.UP)


func _on_exit_down_body_entered(_player : PhysicsBody2D):
	exit_room(Global.Directions.DOWN)
