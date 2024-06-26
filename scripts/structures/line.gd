extends Structure

@onready var polygons_component : PolygonsComponent = $PolygonsComponent
@onready var pulse := $Pulse
@onready var generator_sound_manager := $GeneratorSoundManager

var new_color : Color
var prev_spawned_color : Color

func _ready() -> void:
	super._ready()
	
	var unique_material = pulse.process_material.duplicate()
	pulse.process_material = unique_material
	
	virtual_structure.polygons_generated.connect(make_polygon)

func make_polygon(_polygon_count : int):
	generator_sound_manager.play_random_note()
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
	pulse.modulate = Color.WHITE
	new_color = Global.get_random_color()
	
	pulse.preprocess = 0.0
	pulse.restart()
	pulse.emitting = true
	
	var pulse_color_tween = create_tween()
	pulse_color_tween.tween_interval(0.5)
	pulse_color_tween.tween_property(pulse, 'modulate', new_color, 0.75)

func _load_vfx():
	pulse.restart()
	pulse.preprocess = (virtual_structure.max_cooldown - virtual_structure.cooldown)
	
	pulse.emitting = true
	
	visual.modulate = Global.get_random_color()
