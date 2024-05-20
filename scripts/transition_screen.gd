extends Node2D

func fade_in(duration := 0.5):
	modulate = Color.TRANSPARENT
	
	var tween_in = get_tree().create_tween()
	tween_in.tween_property(self, 'modulate', Color.WHITE, duration)

func fade_out(duration := 0.5):
	modulate = Color.WHITE
	
	var tween_out = get_tree().create_tween()
	tween_out.tween_property(self, 'modulate', Color.TRANSPARENT, duration)
