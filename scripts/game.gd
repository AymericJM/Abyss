extends Node2D

func _ready():
	print("Game ready - Assigning floor depths...")
	assign_floor_depths()

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
			level.apply_darkness()
			print("Assigned ", level_name, " depth: ", floor_mapping[level_name])
		else:
			print("WARNING: Level not found: ", level_name)
