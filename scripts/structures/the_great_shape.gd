extends Structure

signal upgrade_tier_changed(new_tier : int)

@onready var polygon_suck := $PolygonSuck
@onready var rainbow_component := $RainbowComponent
@onready var tooltip := $Tooltip
@onready var upgrade_tier_label := $Tooltip/VBoxContainer/HBoxContainer/UpgradeTier
@onready var cost_label := $Tooltip/VBoxContainer/HBoxContainer/Cost
@onready var description := $Tooltip/VBoxContainer/Description
@onready var action_lines := $ActionLines

@onready var mini_visual_1 := $Visual/MiniVisual
@onready var mini_visual_2 := $Visual/MiniVisual2
@onready var mini_visual_3 := $Visual/MiniVisual3

@onready var mini_visuals := [mini_visual_1, mini_visual_2, mini_visual_3]

var spawned_in := false
var rotation_speed := 0.0
var max_rotation_speed := 0.01

var current_upgrade_tier := 0
var next_upgrade_tier := 1

var upgrade_costs := {
	1: 10000,
	2: 15000,
	3: 20000,
}

func _ready():
	current_upgrade_tier = Stats.upgrade_tier
	super._ready()
	next_upgrade_tier = current_upgrade_tier + 1
	
	upgrade_tier_changed.connect(Global.player.upgrade)
	
	_update_labels()

func _reload():
	super._reload()
	
	get_parent().get_node('View').zoom = Vector2(1.25, 1.25)
	
	_on_spawn_finished()
	_change_upgrade_tier(current_upgrade_tier)
	

func _load():
	var tween_zoom = create_tween()
	tween_zoom.tween_property(get_parent().get_node('View'), 'zoom', Vector2(1.25, 1.25), 1.0)
	
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(visual, 'modulate', Color(1,1,1,1), 1.5)
	
	await tween_fade.finished
	_on_spawn_finished()

func _on_spawn_finished():
	spawned_in = true
	polygon_suck.emitting = true
	rainbow_component.play('color_fading')

func _physics_process(_delta: float) -> void:
	if spawned_in:
		rotation_speed = lerp(rotation_speed, max_rotation_speed, 0.005)
		visual.rotation += rotation_speed
		
		for mini_visual in mini_visuals:
			var mini_rot_speed := rotation_speed * 2.0
			mini_visual.rotation -= mini_rot_speed
	
		

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


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed('click'):
		if upgrade_costs.has(next_upgrade_tier):
			if upgrade_costs[next_upgrade_tier] <= Stats.current_polygons:
				Stats.subtract_polygon(upgrade_costs[next_upgrade_tier])
				current_upgrade_tier += 1
				next_upgrade_tier += 1
				Stats.upgrade_tier = current_upgrade_tier
				
				
				_change_upgrade_tier(current_upgrade_tier)
				_update_labels()

func _change_upgrade_tier(new_upgrade_tier : int) -> void:
	rainbow_component.speed_scale *= 2.0
	
	upgrade_tier_changed.emit(new_upgrade_tier)
	
	match(new_upgrade_tier):
		1:
			max_rotation_speed += 0.05
		2:
			max_rotation_speed += 0.15
		3:
			for mini_visual in mini_visuals:
				var tween = create_tween()
				tween.tween_property(mini_visual, 'modulate:a', 1.0, 1.0)
				
				action_lines.emitting = true
				max_rotation_speed += 7.0
