extends Area2D

@export var charge_time = 2.0
@export var recharge_amount = 100.0
@export var color_dormant: Color = Color(1.0, 0.15, 0.15)
@export var color_charged: Color = Color(0.2, 1.0, 0.4)

@onready var sprite = $AnimatedSprite2D

var player: Player = null
var charge = 0.0
var activated = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	sprite.frame = 0
	sprite.stop()
	sprite.modulate = color_dormant

func _process(delta):
	if activated or player == null:
		return

	if player.is_point_in_flashlight(global_position):
		charge += delta
		_update_animation()
	else:
		var prev_charge = charge
		charge = max(charge - delta * 0.5, 0.0)
		if charge < prev_charge:
			_update_animation()

	if charge >= charge_time:
		activate()

func _update_animation():
	var ratio = charge / charge_time

	if charge > 0 and not activated:
		if not sprite.is_playing():
			sprite.play()
	elif charge == 0:
		sprite.stop()
		sprite.frame = 0

	sprite.modulate = color_dormant.lerp(color_charged, ratio)

func activate():
	if activated:
		return
	activated = true
	sprite.play()
	sprite.modulate = color_charged
	BatteryManager.recharge(recharge_amount)
