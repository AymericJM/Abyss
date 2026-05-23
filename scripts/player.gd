extends CharacterBody2D
class_name Player

@onready var sprite = $AnimatedSprite2D
@onready var flashlight_pivot = $FlashLightPivot
@onready var ray_light = $FlashLightPivot/RayLight
@onready var halo_light = $HaloLight
@onready var light_indicator = get_node_or_null("../CanvasLayer/BatteryHUD/LightIndicator")

const SPEED = 130.0
const BATTERY_IDLE_DRAIN = 2.0
const BATTERY_MOVE_DRAIN = 3.0

const RAY_SCALE_MIN = 1.8
const RAY_SCALE_MAX = 3.0
const RAY_ENERGY_MIN = 0.2
const RAY_ENERGY_MAX = 3.0

@export var flashlight_range = 420.0
@export var flashlight_angle = 35.0

var flashlight_enabled = true
var is_dead = false
var _flicker_tween: Tween = null
var _lights_cut = false

func _ready():
	Events.penultimate_room_entered.connect(_start_flicker)
	Events.final_room_entered.connect(_cut_lights)

func _process(_delta):
	if Input.is_action_just_pressed("flashlight_toggle"):
		flashlight_enabled = !flashlight_enabled

	if not _lights_cut:
		flashlight_pivot.look_at(get_global_mouse_position())
	sprite.rotation = flashlight_pivot.rotation

	if flashlight_enabled and not _lights_cut:
		ray_light.visible = true
		if light_indicator:
			light_indicator.visible = true
		update_lights()
	else:
		ray_light.visible = false
		if light_indicator:
			light_indicator.visible = false
		if not _lights_cut:
			halo_light.visible = true
			halo_light.energy = 0.35

	if BatteryManager.current_battery <= 0 and not is_dead:
		die()

func update_lights():
	var ratio = BatteryManager.get_ratio()
	var ray_scale = lerp(RAY_SCALE_MIN, RAY_SCALE_MAX, ratio)

	ray_light.scale = Vector2.ONE
	ray_light.texture_scale = ray_scale
	ray_light.energy = lerp(RAY_ENERGY_MIN, RAY_ENERGY_MAX, ratio)

	if ray_light.texture:
		ray_light.offset = Vector2((ray_light.texture.get_width() * ray_scale) / 2.085, 0)

	halo_light.energy = lerp(0.35, 0.75, ratio)
	halo_light.texture_scale = lerp(1.8, 2.8, ratio)

func is_point_in_flashlight(point: Vector2) -> bool:
	if not flashlight_enabled:
		return false

	var to_point = point - global_position

	if to_point.length() > flashlight_range:
		return false

	var angle_to_point = abs(rad_to_deg(flashlight_pivot.global_rotation - to_point.angle()))
	angle_to_point = min(angle_to_point, 360.0 - angle_to_point)

	return angle_to_point <= flashlight_angle

func _physics_process(delta):
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

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

func _start_flicker():
	if _flicker_tween:
		_flicker_tween.kill()

	_flicker_tween = create_tween().set_loops()
	_flicker_tween.tween_callback(_flicker_step).set_delay(randf_range(0.04, 0.12))

func _flicker_step():
	if _lights_cut:
		return
	ray_light.visible = !ray_light.visible
	halo_light.visible = !halo_light.visible
	if _flicker_tween:
		_flicker_tween.kill()
	_flicker_tween = create_tween().set_loops()
	_flicker_tween.tween_callback(_flicker_step).set_delay(randf_range(0.03, 0.15))

func _cut_lights():
	_lights_cut = true
	if _flicker_tween:
		_flicker_tween.kill()
		_flicker_tween = null
	ray_light.visible = false
	halo_light.visible = false
	flashlight_enabled = false

func die():
	if is_dead:
		return

	is_dead = true

	var game = get_tree().current_scene

	if game.has_method("player_die"):
		game.player_die()
