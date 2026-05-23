extends Area2D

@onready var sprite = $CthulhuMoonworldIcon
@onready var audio = $AudioStreamPlayer2D
var fade_duration = 10.0
var has_been_activated = false

func _ready():
	sprite.modulate.a = 0.0
	Events.final_room_entered.connect(_on_final_room)

func _on_final_room(_room):
	if has_been_activated:
		return
	has_been_activated = true

	await get_tree().create_timer(5.0).timeout

	audio.play()

	var fade_tween = create_tween()
	fade_tween.tween_property(sprite, "modulate:a", 1.0, fade_duration)

	await get_tree().create_timer(10.0).timeout
	get_tree().quit()
