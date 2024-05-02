extends Node2D

@onready var room_transition_screen_scene := preload('res://scenes/room_transition_screen.tscn')

func _ready():
	Global.register_game_world(self)

func change_rooms(old_room : Node2D, new_room : Node2D, exit_direction : int):
	var player : CharacterBody2D = get_tree().get_first_node_in_group('player')
	
	var transition_screen = room_transition_screen_scene.instantiate()
	add_child(transition_screen)
	
	
	Global.player.state = Global.player.States.DISABLED
	var tween_in = get_tree().create_tween()
	tween_in.tween_property(transition_screen, 'modulate', Color(1,1,1,1), 0.25)
	
	await tween_in.finished
	
	old_room.deload_room()
	new_room.room_exited.connect(change_rooms)
	call_deferred('add_child', new_room)
	new_room.call_deferred('insert_player', player, exit_direction)
	
	var tween_out = get_tree().create_tween()
	tween_out.tween_property(transition_screen, 'modulate', Color(1,1,1,0), 0.25)
	tween_out.tween_callback(transition_screen.queue_free)
	
	await tween_out.finished
	
	Global.player.state = Global.player.States.ACTIVE
