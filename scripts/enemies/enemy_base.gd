extends CharacterBody2D
class_name EnemyBase

@export var speed = 80.0
@export var detection_range = 180.0
@export var max_distance_from_spawn = 350.0

var player: Player = null
var spawn_position: Vector2

func _ready():
	add_to_group("enemy")
	spawn_position = global_position
	find_player()

func find_player():
	for node in get_tree().get_nodes_in_group("player"):
		if node is Player:
			player = node
			return

func move_towards_player():
	if player == null:
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	rotation = direction.angle()

func move_back_to_spawn():
	var direction = (spawn_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	rotation = direction.angle()

func stop_moving():
	velocity = Vector2.ZERO
	move_and_slide()

func _on_body_entered(body):
	if body is Player:
		body.die()
