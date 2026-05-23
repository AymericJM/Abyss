extends EnemyBase

@export var wake_up_delay = 1.5
@export var idle_speed = 25.0
@export var rush_speed = 180.0
@export var change_direction_delay = 1.2

var active = false
var idle_direction = Vector2.RIGHT
var direction_timer = 0.0

func _ready():
	super()
	await get_tree().create_timer(wake_up_delay).timeout
	active = true
	randomize_idle_direction()

func _physics_process(delta):
	if player == null:
		find_player()

	if not active or player == null:
		stop_moving()
		return

	if global_position.distance_to(spawn_position) > max_distance_from_spawn:
		speed = idle_speed
		move_back_to_spawn()
		return

	if player.flashlight_enabled and global_position.distance_to(player.global_position) <= detection_range:
		rush_player()
	else:
		idle_swim(delta)

func idle_swim(delta):
	direction_timer -= delta

	if direction_timer <= 0:
		randomize_idle_direction()

	velocity = idle_direction * idle_speed
	move_and_slide()
	rotation = idle_direction.angle()

func randomize_idle_direction():
	idle_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	direction_timer = change_direction_delay

func rush_player():
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * rush_speed
	move_and_slide()
	rotation = direction.angle()

func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()
