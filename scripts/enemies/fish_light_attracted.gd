extends EnemyBase

@export var wake_up_delay = 1.5

var active = false

func _ready():
	super()
	await get_tree().create_timer(wake_up_delay).timeout
	active = true

func _physics_process(delta):
	if not active or player == null:
		stop_moving()
		return

	if global_position.distance_to(spawn_position) > max_distance_from_spawn:
		move_back_to_spawn()
		return

	if not player.flashlight_enabled:
		stop_moving()
		return

	var distance = global_position.distance_to(player.global_position)

	if distance <= detection_range:
		move_towards_player()
	else:
		stop_moving()
