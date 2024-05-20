extends Node

@onready var click := $Click
@onready var low_click := $LowClick
@onready var tone_1 := $Tone1
@onready var tone_2 := $Tone2

func play_click():
	click.play()

func play_low_click():
	low_click.play()

func play_tone_1():
	tone_1.play()

func play_tone_2():
	tone_2.play()
