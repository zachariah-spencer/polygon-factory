extends Node2D



func _ready():
	Global.register_game_world(self)
	$Room1.load_room()

func change_rooms(old_room : Node2D, new_room : Node2D, exit_direction : int):
	var player : CharacterBody2D = get_tree().get_first_node_in_group('player')
	
	old_room.deload_room()
	new_room.room_exited.connect(change_rooms)
	call_deferred('add_child', new_room)
	new_room.call_deferred('insert_player', player, exit_direction)

