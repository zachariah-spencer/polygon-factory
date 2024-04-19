extends GameObject

@onready var polygon_suck := $PolygonSuck
@onready var color_fading := $ColorFading

var spawned_in := false
var rotation_speed := 0.0

func _ready():
	visual.modulate.a = 0
	
	if purchased:
		_reload()
	else:
		_load()

func _reload():
	super._reload()
	polygon_suck.emitting = true
	spawned_in = true

func _load():
	var tween = get_tree().create_tween()
	tween.tween_property(visual, 'modulate', Color(1,1,1,1), 2.5)
	await tween.finished
	_on_spawn_finished()

func _on_spawn_finished():
	spawned_in = true
	polygon_suck.emitting = true
	color_fading.play('color_fading')

func _physics_process(delta: float) -> void:
	if spawned_in:
		rotation_speed = lerp(rotation_speed, 0.01, 0.001)
		visual.rotation += rotation_speed
