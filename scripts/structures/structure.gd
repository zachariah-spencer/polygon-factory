class_name Structure extends StaticBody2D

@export var purchased := false
@onready var visual := $Visual

var id : String
var virtual_structure : VirtualStructure = null
var creates_polygons := false

func _ready():
	visual.modulate.a = 0
	
	_load_components()
	
	virtual_structure = Structures.register_virtual_structure(id, creates_polygons)
	
	if purchased:
		_reload()
	else:
		_load()

func _load_components():
	if has_node('GeneratorComponent'):
		var generator_component := $GeneratorComponent
		creates_polygons = true
		virtual_structure = Structures.register_virtual_structure(id, creates_polygons)
		virtual_structure.polygons_increment = generator_component.polygons_increment
	
	if has_node('UpgradesComponent'):
		var upgrades_component := $UpgradesComponent
		upgrades_component.upgrade_purchased.connect(activate_upgrade)
		upgrades_component.upgrades_purchased[1] = virtual_structure.upgrade_1_active
		upgrades_component.upgrades_purchased[2] = virtual_structure.upgrade_2_active
		upgrades_component.upgrades_purchased[3] = virtual_structure.upgrade_3_active

### VIRTUAL METHODS ###
func activate_upgrade(_num : int) -> void:
	pass

func _reload():
	visual.modulate.a = 1

func _load():
	var tween = get_tree().create_tween()
	tween.tween_property(visual, 'modulate', Color(1,1,1,1), 0.5)
