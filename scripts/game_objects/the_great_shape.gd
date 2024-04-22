extends GameObject

@onready var polygon_suck := $PolygonSuck
@onready var color_fading := $ColorFading
@onready var tooltip := $Tooltip
@onready var upgrade_tier_label := $Tooltip/VBoxContainer/HBoxContainer/UpgradeTier
@onready var cost_label := $Tooltip/VBoxContainer/HBoxContainer/Cost
@onready var description := $Tooltip/VBoxContainer/Description

var spawned_in := false
var rotation_speed := 0.0

var current_upgrade_tier := 0
var next_upgrade_tier := 1

var upgrade_costs := {
	1: 10000,
	2: 15000,
	3: 20000,
}

func _ready():
	visual.modulate.a = 0
	
	var tween = get_tree().create_tween()
	tween.tween_property(get_parent().get_node('View'), 'zoom', Vector2(1.25, 1.25), 2.0).set_ease(tween.EASE_OUT_IN)
	
	current_upgrade_tier = Stats.upgrade_tier
	next_upgrade_tier = current_upgrade_tier + 1
	_update_labels()
	
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

func _update_labels():
	upgrade_tier_label.text = 'Upgrade Tier - ' + str(current_upgrade_tier)
	if upgrade_costs.has(next_upgrade_tier):
		cost_label.text = 'Cost - ' + str(upgrade_costs[next_upgrade_tier]) + ' Polygons'
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(cost_label, 'modulate', Color.TRANSPARENT, 0.25)
		description.text = 'The Great Shape is very\npleased with you.'

func _on_mouse_entered() -> void:
	print('LOL')
	var tween = get_tree().create_tween()
	tween.tween_property(tooltip, 'modulate', Color.WHITE, 0.25)


func _on_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(tooltip, 'modulate', Color.TRANSPARENT, 0.25)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed('click'):
		if upgrade_costs.has(next_upgrade_tier):
			if upgrade_costs[next_upgrade_tier] <= Stats.current_polygons:
				Stats.subtract_polygon(upgrade_costs[next_upgrade_tier])
				current_upgrade_tier += 1
				next_upgrade_tier += 1
				Stats.upgrade_tier = current_upgrade_tier
				
				_update_labels()
