extends GameObject

@onready var pulse := $Pulse
@onready var quality_pulse := $QualityPulse
@onready var collision := $Collision
@onready var polygons := $Polygons

var prev_spawned_color : Color

func make_polygon(_polygon_count : int):
	_emit_pulse_vfx()
	
	prev_spawned_color = _spawn_polygon()
	
	var tween = get_tree().create_tween()
	tween.tween_property(visual, 'modulate', prev_spawned_color, 0.2)

func activate_upgrade_1():
	generator.max_cooldown *= 0.5
	
	pulse.speed_scale *= 2.0
	
	generator.upgrade_1_active = true

func activate_upgrade_2():
	generator.polygons_increment *= 2
	
	var tween = get_tree().create_tween()
	tween.tween_property(quality_pulse, 'modulate', Color.WHITE, 0.5)
	
	generator.upgrade_2_active = true

func _ready():
	generator.polygons_generated.connect(make_polygon)
	visual.modulate.a = 0
	var rand_rot := randf_range(0, 360)
	rotation = rand_rot
	
	if purchased:
		_reload()
	else:
		_load()

func _reload():
	super._reload()
	_load_vfx()
	
	if generator.upgrade_1_active:
		pulse.speed_scale *= 2.0
	
	if generator.upgrade_2_active:
		quality_pulse.modulate.a = 1.0

func _spawn_polygon() -> Color:
	var polygon_scene = load(polygon_scene_path)
	var new_triangle_color := Color.WHITE
	var polygon_instance = polygon_scene.instantiate()
	
	polygon_instance.global_position = global_position
	polygons.add_child(polygon_instance)
	new_triangle_color = polygon_instance.initial_color
	
	return new_triangle_color

func _emit_pulse_vfx():
	pulse.preprocess = 0.0
	pulse.restart()
	pulse.emitting = true
	
	quality_pulse.preprocess = 0.0
	

func _load_vfx():
	pulse.preprocess = (generator.max_cooldown - generator.cooldown)
	pulse.restart()
	pulse.emitting = true
	
	quality_pulse.preprocess = (generator.max_cooldown - generator.cooldown)
	quality_pulse.restart()
	quality_pulse.emitting = true
	visual.modulate = Global.get_random_color()

func _physics_process(_delta: float) -> void:
	rotation += 0.02

func _on_mouse_entered() -> void:
	if not upgrades_menu_active:
		_spawn_upgrades_menu()
