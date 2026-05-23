extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var flashlight_pivot = $FlashLightPivot
@onready var ray_light = $FlashLightPivot/RayLight
@onready var halo_light = $HaloLight
@onready var light_indicator = $"../CanvasLayer/BatteryHUD/LightIndicator"

const SPEED = 200.0

const BATTERY_IDLE_DRAIN = 0.8
const BATTERY_MOVE_DRAIN = 1.5

const RAY_SCALE_MIN = 1.8
const RAY_SCALE_MAX = 3.0
const RAY_ENERGY_MIN = 0.2
const RAY_ENERGY_MAX = 3.0

var flashlight_enabled = true

func _process(delta):
	if Input.is_action_just_pressed("flashlight_toggle"):
		flashlight_enabled = !flashlight_enabled

	flashlight_pivot.look_at(get_global_mouse_position())
	sprite.rotation = flashlight_pivot.rotation

	if flashlight_enabled:
		ray_light.visible = true
		light_indicator.visible = true
		update_lights()
	else:
		ray_light.visible = false
		light_indicator.visible = false
		halo_light.visible = true
		halo_light.energy = 0.35

func update_lights():
	var ratio = BatteryManager.get_ratio()

	var ray_scale = lerp(RAY_SCALE_MIN, RAY_SCALE_MAX, ratio)

	ray_light.scale = Vector2.ONE
	ray_light.texture_scale = ray_scale
	ray_light.energy = lerp(RAY_ENERGY_MIN, RAY_ENERGY_MAX, ratio)
	ray_light.blend_mode = 2

	if ray_light.texture:
		ray_light.offset = Vector2((ray_light.texture.get_width() * ray_scale) / 2.085, 0)

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

	if flashlight_enabled:
		BatteryManager.drain(drain * delta)

	velocity = direction * SPEED
	move_and_slide()

	if direction.length() > 0:
		if not sprite.is_playing():
			sprite.play()
	else:
		sprite.stop()
