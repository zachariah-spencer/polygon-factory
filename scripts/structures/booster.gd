extends Structure

@onready var cockpit_area := $CockpitArea
@onready var cockpit_empty_pulse := $CockpitEmptyPulse
@onready var cockpit_piloted_pulse := $CockpitPilotedPulse
@onready var boost_orb := $BoostOrb

var piloted := false
var cockpit_exit_offset := Vector2(0, 32)

var distance := 0.0
var radius := 106.0
var speed := 0.75

func _ready() -> void:
	pass

func _on_cockpit_area_body_entered(player : Node2D) -> void:
	if not player.exiting_cockpit.is_connected(eject_player):
		player.exiting_cockpit.connect(eject_player)
	player.state = player.States.PILOTING
	player.velocity = Vector2.ZERO
	player.global_position = cockpit_area.global_position
	
	piloted = true
	_toggle_cockpit_vfx()

func eject_player(player : Node2D) -> void:
	player.global_position = cockpit_area.global_position + cockpit_exit_offset
	player.state = player.States.ACTIVE
	
	piloted = false
	_toggle_cockpit_vfx()

func _toggle_cockpit_vfx():
	cockpit_empty_pulse.restart()
	cockpit_empty_pulse.emitting = not piloted
	cockpit_empty_pulse.visible = not piloted
	
	cockpit_piloted_pulse.restart()
	cockpit_piloted_pulse.emitting = piloted
	cockpit_piloted_pulse.visible = piloted

func _process(delta: float) -> void:
	distance -= delta
	var orbit_position := Vector2(sin(distance * speed) * radius, cos(distance * speed) * radius)
	
	boost_orb.global_position = orbit_position
