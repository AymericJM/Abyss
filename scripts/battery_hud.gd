extends Control

@onready var bar = $TextureProgressBar
@onready var label = $Label

func _process(delta):
	var battery = BatteryManager.current_battery
	var ratio = BatteryManager.get_ratio()

	bar.value = battery
	label.text = str(int(battery)) + "%"

	if ratio > 0.66:
		bar.modulate = Color(0.5, 0.9, 1.0)
		label.modulate = Color(0.5, 0.9, 1.0)
	elif ratio > 0.33:
		bar.modulate = Color(1.0, 0.9, 0.2)
		label.modulate = Color(1.0, 0.9, 0.2)
	else:
		bar.modulate = Color(1.0, 0.2, 0.2)
		label.modulate = Color(1.0, 0.2, 0.2)
