extends TextureRect

@export var max_alpha: float = 0.75
@export var threshold: float = 100.0
@export var transition_speed: float = 3.0

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	stretch_mode = TextureRect.STRETCH_TILE
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	modulate.a = 0.0

func _process(delta: float) -> void:
	var ratio: float = BatteryManager.get_ratio()
	var battery: float = BatteryManager.current_battery
	var target_alpha: float

	if battery >= threshold:
		target_alpha = 0.0
	else:
		target_alpha = max_alpha * (1.0 - battery / threshold)
	modulate.a = lerp(modulate.a, target_alpha, transition_speed * delta)
