extends Node

@onready var message_timer := $MessageTimer
@onready var tip := $CenterContainer/Tip
@export var tutorials_enabled := true

var intro_1 := ['Welcome to the Polygon Factory...', false, 2.0]
var intro_2 := ['Accumulate as many polygons as possible...', false, 1.5]
var intro_3 := ['Begin your journey by clicking the white diamond...', false, 1.5]

var structure_1 := ['Structures generate polygons passively...', false, 1.5]
var structure_2 := ['You can purchase them by mousing over the gray icons on the map...', false, 1.5]

var booster_1 := ['Enter the center to pilot the polygon booster...', false, 1.5]
var booster_2 := ['To complete a boost, you must press the\n
					press the space bar when the boost orb is\n
					passing over the white square...', false, 3.5]
var booster_3 := ['Completing multiple consecutive boosts will\n
					add multipliers to all polygons produced throughout\n
					the facility until your streak ends...', false, 3.5]
var booster_4 := ['To exit the cockpit, press the Q key', false, 1.5]

var intros := [intro_1, intro_2, intro_3]
var structures := [structure_1, structure_2]
var boosters := [booster_1, booster_2, booster_3, booster_4]

var displaying_message := false
var displaying_messages := false

var message_queue := []
var last_message_displayed : Array

func _ready():
	Global.structure_hovered.connect(_queue_structure_tutorial)
	Global.booster_room_entered.connect(_queue_booster_tutorial)
	
	tip.modulate = Color.TRANSPARENT
	await Global.game_loaded
	queue_message(intros)

func _queue_structure_tutorial():
	queue_message(structures)

func _queue_booster_tutorial():
	queue_message(boosters)

func _process(_delta: float) -> void:
	if tutorials_enabled:
		if not displaying_message and not message_queue.is_empty():
			displaying_messages = true
			displaying_message = true
			Global.player.change_state(Global.player.States.DISABLED)
			var latest_message = message_queue.front()
			message_queue.pop_front()
			var duration = latest_message[2]
			show_message(latest_message, duration)

func set_message_block_played(message_block : Array, played : bool):
	for message in message_block:
		message[1] = played

func get_message_block_played(message_block : Array) -> bool:
	var played := true
	for message in message_block:
		if not message[1]:
			played = false
	
	return played

func queue_message(message_block : Array):
	if not displaying_message:
		for message in message_block:
			if not message[1]:
				message_queue.append(message)
	elif message_block == boosters:
		for message in message_block:
			if not message[1]:
				message_queue.append(message)

func show_message(message : Array, duration := 2.0):
	var tween = get_tree().create_tween()
	message[1] = true
	
	tip.text = message[0]
	
	tween.tween_property(tip, 'modulate', Color.WHITE, 0.5)
	tween.tween_interval(duration)
	tween.tween_property(tip, 'modulate', Color.TRANSPARENT, 0.5)
	message_timer.start(duration + 1.0)
	
	last_message_displayed = message
	if message_queue.is_empty():
		displaying_messages = false


func _on_message_timer_timeout() -> void:
	displaying_message = false
	
	if not displaying_messages:
		Global.player.change_state(Global.player.States.ACTIVE)
