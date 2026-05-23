extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var flashlight_pivot = $FlashLightPivot
@onready var ray_light = $FlashLightPivot/RayLight
@onready var halo_light = $HaloLight

const SPEED = 200.0

const BATTERY_IDLE_DRAIN = 0.8
const BATTERY_MOVE_DRAIN = 1.5

func _process(delta):
	flashlight_pivot.look_at(get_global_mouse_position())
	sprite.rotation = flashlight_pivot.rotation

	update_lights()

func update_lights():
	var ratio = BatteryManager.get_ratio()

	ray_light.energy = lerp(0.15, 1.2, ratio)
	ray_light.texture_scale = lerp(0.8, 2.8, ratio)

	halo_light.energy = lerp(0.35, 0.75, ratio)
	halo_light.texture_scale = lerp(1.8, 2.8, ratio)

func _physics_process(delta):
	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	var drain = BATTERY_IDLE_DRAIN

	if direction.length() > 0:
		drain += BATTERY_MOVE_DRAIN

	BatteryManager.drain(drain * delta)

	velocity = direction * SPEED
	move_and_slide()

	if direction.length() > 0:
		if not sprite.is_playing():
			sprite.play()
	else:
		sprite.stop()
