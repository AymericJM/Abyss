extends Node2D


func _on_charge_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.charge_battery.emit()
