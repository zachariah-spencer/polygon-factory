extends Structure

@onready var polygons_component : PolygonsComponent = $PolygonsComponent
@onready var pulse := $Pulse

var new_color : Color
var prev_spawned_color : Color

func _ready() -> void:
	super._ready()
	virtual_structure.polygons_generated.connect(make_polygon)

func make_polygon(_polygon_count : int):
	_emit_pulse_vfx()
	
	if polygons_component:
		prev_spawned_color = polygons_component.spawn_polygon(new_color)
	
	var tween = get_tree().create_tween()
	tween.tween_property(visual, 'modulate', prev_spawned_color, 0.2)

func _load():
	super._load()
	_emit_pulse_vfx()

func _reload():
	super._reload()
	_load_vfx()

func _emit_pulse_vfx():
	pulse.preprocess = 0.0
	pulse.restart()
	pulse.emitting = true
	
	new_color = Global.get_random_color()
	
	pulse.process_material.set('color', new_color)

func _load_vfx():
	print(virtual_structure.max_cooldown - virtual_structure.cooldown)
	pulse.preprocess = (virtual_structure.max_cooldown - virtual_structure.cooldown)
	pulse.restart()
	pulse.emitting = true
	
	visual.modulate = Global.get_random_color()
