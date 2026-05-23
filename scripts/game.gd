extends Node2D

var is_restarting = false
var death_overlay: ColorRect

func _ready():
	create_death_overlay()
	$Music.play()
	assign_floor_depths()

func create_death_overlay():
	death_overlay = ColorRect.new()
	death_overlay.name = "DeathOverlay"
	death_overlay.size = Vector2(640, 360)
	death_overlay.color = Color(1, 1, 1, 0)
	death_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var canvas = get_node_or_null("CanvasLayer")
	if canvas == null:
		canvas = CanvasLayer.new()
		canvas.name = "CanvasLayer"
		add_child(canvas)

	canvas.add_child(death_overlay)

func player_die():
	if is_restarting:
		return

	is_restarting = true
	get_tree().paused = true

	death_overlay.color = Color(1, 1, 1, 1)
	await get_tree().create_timer(0.12, true).timeout

	death_overlay.color = Color(0, 0, 0, 0)

	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(death_overlay, "color", Color(0, 0, 0, 1), 0.7)

	await tween.finished

	get_tree().paused = false
	BatteryManager.reset()
	get_tree().reload_current_scene()

func assign_floor_depths():
	var floor_mapping = {
		"Level0": 0,
		"Level1": 1,
		"Level2": 1,
		"Level3": 1,
		"Level4": 1,
		"Level5": 1,
		"Level6": 2,
		"Level7": 3,
		"Level8": 3,
		"Level9": 3,
		"Level10": 4,
		"Level11": 4,
		"Level12": 5,
		"Level13": 5,
		"Level14": 5,
		"Level15": 5,
		"Level16": 6,
		"Level17": 6,
	}

	for level_name in floor_mapping:
		var level = get_node_or_null(level_name)

		if level:
			level.floor_depth = floor_mapping[level_name]
			level.room_index = int(level_name.replace("Level", ""))
			level.apply_darkness()
