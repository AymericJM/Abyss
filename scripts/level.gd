extends Node2D

@export var floor_depth: int = 0
@export var room_index: int = 0

func apply_darkness():
	if has_node("DarknessOverlay"):
		$DarknessOverlay.queue_free()

	var overlay = ColorRect.new()
	overlay.name = "DarknessOverlay"
	overlay.color = Color(0, 0, 0, 0)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.size = Vector2(640, 360)
	overlay.position = Vector2(0, 0)

	var alpha = floor_depth * 0.20
	alpha = min(alpha, 0.9)
	overlay.color.a = alpha

	add_child(overlay)

func _on_room_center_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.room_entered.emit(self)

		if room_index == 16:
			Events.penultimate_room_entered.emit()
		elif room_index == 17:
			Events.final_room_entered.emit()
