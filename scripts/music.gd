extends AudioStreamPlayer

const PLAYER_MIN_Y: float = 0
const PLAYER_MAX_Y: float = 360
const ZERO_VOLUME: int = -40

@export var player: CharacterBody2D
@export var transition: float

var ymin: float
var ymax: float

func _ready() -> void:
	set_transition(3)
	
func set_transition(value: float):
	transition = value
	compute_x_bounds()
	
func compute_x_bounds():
	var d = PLAYER_MAX_Y - PLAYER_MIN_Y
	ymin = PLAYER_MAX_Y + (d - d * transition) / 2.0
	ymax = PLAYER_MIN_Y + (d + d * transition) / 2.0

func _process(_delta: float):
	var py = player.global_position.y
	var r = inverse_lerp(ymin, ymax, py)
	
	stream.set_sync_stream_volume(1, min(ZERO_VOLUME + r * (-ZERO_VOLUME), 0.00))
	stream.set_sync_stream_volume(0, min(ZERO_VOLUME + (1.0 - r) * (-ZERO_VOLUME), 0.00))
