class_name GameObject extends StaticBody2D
# Is inherited by Generator

@export var polygon_scene_path : String
@export var purchased := false
@onready var visual := $Visual

var id : String
var virtual_structure : VirtualStructure = null

func _ready():
	visual.modulate.a = 0
	
	_load_components()
	
	if purchased:
		_reload()
	else:
		_load()

func _load_components():
	if has_node('GeneratorComponent'):
		var generator_component := $GeneratorComponent
		virtual_structure = Objects.get_object(id, true, generator_component.polygons_generated)
		
		#TODO: After virtual objects are refactored, this can be moved out of nested 
		#if statement to allow for objects to have visual upgrades without a GeneratorComponent.
		if has_node('UpgradesComponent'):
			var upgrades_component := $UpgradesComponent
			upgrades_component.upgrade_purchased.connect(activate_upgrade)
			upgrades_component.upgrades_purchased[1] = virtual_structure.upgrade_1_active
			upgrades_component.upgrades_purchased[2] = virtual_structure.upgrade_2_active
			upgrades_component.upgrades_purchased[3] = virtual_structure.upgrade_3_active
	else:
		Objects.get_object(id)

### VIRTUAL METHODS ###
func activate_upgrade(_num : int) -> void:
	pass

func _reload():
	visual.modulate.a = 1

func _load():
	var tween = get_tree().create_tween()
	tween.tween_property(visual, 'modulate', Color(1,1,1,1), 0.5)
