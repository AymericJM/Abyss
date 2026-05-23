extends Node

var current_battery = 100.0
const MAX_BATTERY = 100.0

func _ready():
	Events.charge_battery.connect(func():
		current_battery = 100.0
		)
	reset()

func reset():
	current_battery = MAX_BATTERY

func drain(amount):
	current_battery = max(current_battery - amount, 0.0)

func recharge(amount):
	current_battery = min(current_battery + amount, MAX_BATTERY)

func get_ratio():
	return current_battery / MAX_BATTERY
