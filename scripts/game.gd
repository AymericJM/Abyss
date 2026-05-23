extends Node2D

var room_debug: Label

func _ready():
	create_room_debug()
	$Music.play()
	assign_floor_depths()

func create_room_debug():
	var canvas = get_node_or_null("CanvasLayer")

	if canvas == null:
		canvas = CanvasLayer.new()
		canvas.name = "CanvasLayer"
		add_child(canvas)

	room_debug = canvas.get_node_or_null("RoomDebug")

	if room_debug == null:
		room_debug = Label.new()
		room_debug.name = "RoomDebug"
		room_debug.position = Vector2(10, 10)
		room_debug.text = "ROOM ?"
		canvas.add_child(room_debug)

func update_room_debug(room_index):
	if room_debug == null:
		create_room_debug()

	room_debug.text = "ROOM " + str(room_index)

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
