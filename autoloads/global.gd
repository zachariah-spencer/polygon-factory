extends Node

enum Directions {LEFT, RIGHT, UP, DOWN, NULL = -1}

var game_world
var background_objects


func register_game_world(in_game_world):
	game_world = in_game_world

func register_background_objects(in_background_objects):
	background_objects = in_background_objects
