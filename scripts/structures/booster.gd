extends Structure

@onready var cockpit_area := $CockpitArea
@onready var cockpit_empty_pulse := $CockpitEmptyPulse
@onready var cockpit_piloted_pulse := $CockpitPilotedPulse
@onready var boost_orb := $BoostOrb
@onready var boost_area := $BoostArea
@onready var boost_cooldown := $BoostCooldown
@onready var streak_label := $StreakInfo/StreakLabel
@onready var polygon_combo_label := $StreakInfo/PolygonComboLabel
@onready var anims := $Anims
@onready var success_visual := $Visual/SuccessVisual
@onready var streak_high_score_label := $StreakInfo/StreakHighScoreLabel
@onready var orb_vfx_trail := $BoostOrb/VFX/Trail

var piloted := false
var cockpit_exit_offset := Vector2(0, 32)
var streak := 0
var streak_high_score := 0
var boost_on_cooldown := true

var base_boost_amount := 1.0
var unpiloted_base_speed := 0.75
var piloted_base_speed := 1.5
var speed := unpiloted_base_speed
var target_speed := unpiloted_base_speed

func _ready() -> void:
	success_visual.modulate = Color('ffffff7c')
	orb_vfx_trail.emitting = true
	streak_high_score = Stats.boost_streak
	streak_high_score_label.text = 'Best\n' + str(streak_high_score)

func _on_cockpit_area_body_entered(player : Node2D) -> void:
	if not player.exiting_cockpit.is_connected(eject_player):
		player.exiting_cockpit.connect(eject_player)
	player.state = player.States.PILOTING
	player.velocity = Vector2.ZERO
	player.global_position = cockpit_area.global_position
	
	piloted = true
	_toggle_cockpit_vfx()
	target_speed = piloted_base_speed

func eject_player(player : Node2D) -> void:
	player.global_position = cockpit_area.global_position + cockpit_exit_offset
	player.state = player.States.ACTIVE
	
	piloted = false
	_toggle_cockpit_vfx()
	target_speed = unpiloted_base_speed
	for structure_id in Structures.virtual_structures:
		Structures.virtual_structures[structure_id].polygons_boost = 1

func _toggle_cockpit_vfx():
	cockpit_empty_pulse.restart()
	cockpit_empty_pulse.emitting = not piloted
	cockpit_empty_pulse.visible = not piloted
	
	cockpit_piloted_pulse.restart()
	cockpit_piloted_pulse.emitting = piloted
	cockpit_piloted_pulse.visible = piloted

func _physics_process(delta: float) -> void:
	if piloted:
		_handle_pilot_input()
	
	speed = lerp(speed, target_speed, 0.01)
	boost_orb.rotation += delta * speed

func _is_boost_successful():
	return boost_area.get_overlapping_bodies().size() != 0

func _handle_pilot_input():
	if Input.is_action_just_pressed('boost'):
		if _is_boost_successful():
			_boost()
		else:
			_end_streak()

func _boost():
	var new_speed := target_speed + base_boost_amount + float(streak / 4.0)
	speed += new_speed
	
	speed = clamp(speed, 0.0, 13.0)
	
	_increment_streak()
	anims.play('successful_boost')
	
	boost_on_cooldown = true
	boost_cooldown.start()

func _increment_streak():
	streak += 1
	streak_label.text = 'Streak\n' + str(streak)
	
	if streak > streak_high_score:
		Stats.boost_streak = streak
		streak_high_score = streak
		streak_high_score_label.text = 'Best\n' + str(streak_high_score)
	
	match(streak):
		5:
			for structure_id in Structures.virtual_structures:
				Structures.virtual_structures[structure_id].polygons_boost = 2
				
			var tween = create_tween()
			tween.tween_property(polygon_combo_label, 'modulate', Color.WHITE, 0.2)
			polygon_combo_label.text = '2x Polygons!'
		10:
			for structure_id in Structures.virtual_structures:
				Structures.virtual_structures[structure_id].polygons_boost = 3
			polygon_combo_label.text = '3x Polygons!'
		15:
			for structure_id in Structures.virtual_structures:
				Structures.virtual_structures[structure_id].polygons_boost = 4
			polygon_combo_label.text = '4x Polygons!'

func _end_streak():
	if streak != 0:
		speed = clamp(speed * 0.5, piloted_base_speed, 100000.0)
	
	streak = 0
	streak_label.text = 'Streak\n' + str(streak)
	
	var tween = create_tween()
	tween.tween_property(polygon_combo_label, 'modulate', Color.TRANSPARENT, 0.2)
	
	for structure_id in Structures.virtual_structures:
		Structures.virtual_structures[structure_id].polygons_boost = 1
	
	anims.play('failed_boost')


func _on_boost_area_body_exited(_body: Node2D) -> void:
	if not boost_on_cooldown and streak != 0:
		_end_streak()


func _on_boost_cooldown_timeout() -> void:
	boost_on_cooldown = false


func _on_tree_exiting() -> void:
	_end_streak()
