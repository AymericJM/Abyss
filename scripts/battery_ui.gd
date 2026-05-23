extends Control

@onready var icon = $BatteryIcon

func _process(delta):
	var battery = BatteryManager.current_battery

	if battery <= 0:
		icon.frame = 6
		set_color(Color(0.4, 0.4, 0.4))

	elif battery <= 15:
		icon.frame = 5
		set_color(Color(1.0, 0.2, 0.2))

	elif battery <= 30:
		icon.frame = 4
		set_color(Color(1.0, 0.4, 0.2))

	elif battery <= 45:
		icon.frame = 3
		set_color(Color(1.0, 0.8, 0.2))

	elif battery <= 60:
		icon.frame = 2
		set_color(Color(0.9, 1.0, 0.3))

	elif battery <= 80:
		icon.frame = 1
		set_color(Color(0.6, 1.0, 0.8))

	else:
		icon.frame = 0
		set_color(Color(0.5, 0.9, 1.0))

func set_color(color):
	icon.modulate = color
