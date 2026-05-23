extends TextureRect

@onready var tension_sound: AudioStreamPlayer = $Tension

@export var max_alpha: float = 0.20
@export var threshold: float = 50.0
@export var transition_speed: float = 2.0


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	modulate.a = 0.0
	tension_sound.volume_db = -80.0
	tension_sound.play()

func _process(delta: float) -> void:
	var battery: float = BatteryManager.current_battery
	var target_alpha: float
	if battery >= threshold:
		target_alpha = 0.0
	else:
		target_alpha = max_alpha * (1.0 - battery / threshold)
	modulate.a = lerp(modulate.a, target_alpha, transition_speed * delta)
	tension_sound.volume_db = lerp(-40.0, 0.0, modulate.a / max_alpha)
