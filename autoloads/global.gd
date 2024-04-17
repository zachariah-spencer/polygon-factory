extends Node

enum Directions {LEFT, RIGHT, UP, DOWN, NULL = -1}

var game_world
var background_objects
var player

var colors = [
	Color.DARK_RED,
	Color.BLUE_VIOLET,
	Color.YELLOW,
	Color.SEA_GREEN,
	Color.AQUAMARINE,
	Color.CRIMSON,
	Color.DARK_ORANGE,
	Color.LIGHT_GREEN,
	Color.MIDNIGHT_BLUE,
	Color.POWDER_BLUE,
	Color.TOMATO,
	Color.KHAKI
]

func get_random_color() -> Color:
	return colors[randi_range(0,(Global.colors.size() - 1))]

func register_game_world(in_game_world):
	game_world = in_game_world

func register_background_objects(in_background_objects):
	background_objects = in_background_objects
