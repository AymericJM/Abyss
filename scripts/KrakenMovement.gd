extends Area2D

@onready var sprite = $Sprite2D
@onready var audio = $AudioStreamPlayer2D
var move_duration = 0.5
var has_been_activated = false

func _ready():
	var screen_width = get_viewport_rect().size.x
	sprite.global_position.x = screen_width + 200

	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is CharacterBody2D and not has_been_activated:
		has_been_activated = true
		audio.play()

		var tween = create_tween()
		tween.tween_property(sprite, "global_position:x", -600, move_duration)
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_CUBIC)

		tween.parallel().tween_property(sprite, "modulate:a", 0.0, move_duration * 0.5).set_delay(move_duration * 0.5)
