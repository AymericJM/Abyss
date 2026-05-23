extends Area2D

@onready var sprite = $CthulhuMoonworldIcon
@onready var audio = $AudioStreamPlayer2D
var fade_duration = 10.0
var has_been_activated = false

func _ready():
	sprite.modulate.a = 0.0
	Events.final_room_entered.connect(_on_final_room)

func _on_final_room():
	if has_been_activated:
		return
	has_been_activated = true

	audio.play()

	var player = get_tree().get_first_node_in_group("player")
	if player:
		var pivot = player.get_node_or_null("FlashLightPivot")
		var ray = player.get_node_or_null("FlashLightPivot/RayLight")
		if pivot and ray:
			ray.visible = true
			player.flashlight_enabled = true
			var tween = create_tween()
			tween.tween_method(
				func(t: float):
					var angle = pivot.global_rotation
					var target = (global_position - player.global_position).angle()
					pivot.global_rotation = lerp_angle(angle, target, t),
				0.0, 1.0, 1.5
			)

	var fade_tween = create_tween()
	fade_tween.tween_property(sprite, "modulate:a", 1.0, fade_duration)

	await get_tree().create_timer(10.0).timeout
	get_tree().quit()
