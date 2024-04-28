class_name VirtualStructure extends Resource

var creates_polygons := false
var max_cooldown := 1.0
var polygons_increment := 1

var upgrade_1_active := false
var upgrade_2_active := false
var upgrade_3_active := false

signal polygons_generated(polygons :  int)

var cooldown : float = max_cooldown

func _init(creates : bool, increment : int, cd : float) -> void:
	creates_polygons = creates
	polygons_increment = increment
	max_cooldown = cd
	cooldown = cd

func reduce_cooldown_by(amount : float):
	cooldown -= amount
	while cooldown <= 0.0:
		cooldown = max_cooldown
		polygons_generated.emit(polygons_increment)
