extends Node

@onready var audio_clip := get_parent()
@export var duration := 1.0

func _ready():
	audio_clip.volume_db = -80.0
	
	var tween = create_tween()
	tween.tween_property(audio_clip, 'pitch_scale', 1.0, duration) 
