extends Structure

@onready var pulse := $Pulse
@onready var quality_pulse := $QualityPulse
@onready var collision := $Collision
@onready var polygons_component : PolygonsComponent = $PolygonsComponent

var prev_spawned_color : Color
var rot_speed := 0.02

func make_polygon(_polygon_count : int):
	_emit_pulse_vfx()
	
	if polygons_component:
		prev_spawned_color = polygons_component.spawn_polygon()
	
	var tween = get_tree().create_tween()
	tween.tween_property(visual, 'modulate', prev_spawned_color, 0.2)

func activate_upgrade(num : int) -> void:
	match(num):
		1:
			virtual_structure.max_cooldown *= 0.5
			
			pulse.speed_scale *= 2.0
			rot_speed *= 2.0
			
			virtual_structure.upgrade_1_active = true
		2:
			virtual_structure.polygons_increment *= 2
			
			pulse.modulate = Color.AQUA
			var tween = get_tree().create_tween()
			tween.tween_property(quality_pulse, 'modulate', Color.WHITE, 0.5)
			
			virtual_structure.upgrade_2_active = true

func _ready():
	super._ready()
	
	var rand_rot := randf_range(0, 360)
	rotation = rand_rot
	
	virtual_structure.polygons_generated.connect(make_polygon)

func _reload():
	super._reload()
	_load_vfx()
	
	if virtual_structure.upgrade_1_active:
		pulse.speed_scale *= 2.0
		rot_speed *= 2.0
	
	if virtual_structure.upgrade_2_active:
		quality_pulse.modulate.a = 1.0
		pulse.modulate = Color.AQUA

func _emit_pulse_vfx():
	pulse.preprocess = 0.0
	pulse.restart()
	pulse.emitting = true
	
	quality_pulse.preprocess = 0.0

func _load_vfx():
	pulse.preprocess = (virtual_structure.max_cooldown - virtual_structure.cooldown)
	pulse.restart()
	pulse.emitting = true
	
	quality_pulse.preprocess = (virtual_structure.max_cooldown - virtual_structure.cooldown)
	quality_pulse.restart()
	quality_pulse.emitting = true
	visual.modulate = Global.get_random_color()

func _physics_process(_delta: float) -> void:
	rotation += rot_speed
