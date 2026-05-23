extends AudioStreamPlayer

@export var player: CharacterBody2D
@export var full_volumes: Array[float] = [-15.0, -20.0, 0.0]

const ZERO_VOLUME: float = -60.0
const FADE_HALF_WIDTH: float = 180.0

var transition_points: Array[float] = [1080.0, 1800.0]

func _process(_delta: float) -> void:
	var py := player.global_position.y
	for i in range(transition_points.size() + 1):
		stream.set_sync_stream_volume(i, _track_volume(py, i))

func _track_volume(py: float, i: int) -> float:
	var left       := transition_points[i - 1] - FADE_HALF_WIDTH if i > 0 else -INF
	var peak_start := transition_points[i - 1] + FADE_HALF_WIDTH if i > 0 else -INF
	var peak_end   := transition_points[i] - FADE_HALF_WIDTH if i < transition_points.size() else INF
	var right      := transition_points[i] + FADE_HALF_WIDTH if i < transition_points.size() else INF
	var w: float

	if py <= left or py >= right:
		w = 0.0
	elif py >= peak_start and py <= peak_end:
		w = 1.0
	elif py < peak_start:
		w = inverse_lerp(left, peak_start, py)
	else:
		w = 1.0 - inverse_lerp(peak_end, right, py)

	return lerp(ZERO_VOLUME, full_volumes[i], w)
