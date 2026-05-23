extends Area2D

@onready var sprite = $CthulhuMoonworldIcon
@onready var audio = $AudioStreamPlayer2D
var fade_duration = 10.0
var has_been_activated = false

func _ready():
	sprite.modulate.a = 0.0
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player" and not has_been_activated:
		has_been_activated = true
		
		audio.play()
		
		var tween = create_tween()
		tween.tween_property(sprite, "modulate:a", 1.0, fade_duration)
