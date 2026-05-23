extends CharacterBody2D

var max_speed = 200
var last_direction := Vector2(1, 0)

func _ready() -> void:
	play_swim_animation(last_direction)

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * max_speed
	move_and_slide()
	
	if direction.length() > 0:
		last_direction = direction
		play_swim_animation(direction)
	
func play_swim_animation(direction):
	if direction.x > 0:
		$AnimatedSprite2D.play("swim_right")
	elif direction.x < 0:
		$AnimatedSprite2D.play("swim_left")
