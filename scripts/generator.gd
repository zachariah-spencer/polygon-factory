class_name Generator extends GameObject

var max_cooldown := 1.0
var polygons_increment := 1

signal polygons_generated(polygons :  int)

var cooldown := max_cooldown

func reduce_cooldown_by(amount : float):
	cooldown -= amount
	while cooldown <= 0.0:
		cooldown += max_cooldown
		polygons_generated.emit(polygons_increment)
