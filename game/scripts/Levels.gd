class_name Levels
extends RefCounted

# All coordinates are in level/world pixels. Platform rects are (x, y, w, h)
# with y measured downward from the level's top; a platform's y is the top
# of its collision box. Gaps between platform rects are pits: walking off
# one and falling past the level's bottom respawns the player at their spawn.
# Crates are pushable (RigidBody2D) and can be shoved to climb ledges that
# are too tall to jump directly.

static func all() -> Array:
	return [_level1(), _level2(), _level3(), _level4(), _level5()]

static func _level1() -> Dictionary:
	return {
		"name": "Level 1",
		"size": Vector2(1800, 720),
		"bg_color": Color(0.55, 0.78, 0.92),
		"platforms": [
			Rect2(0, 650, 520, 70),
			Rect2(650, 650, 480, 70),
			Rect2(1260, 650, 540, 70),
			Rect2(760, 540, 160, 30),
		],
		"crates": [],
		"spawn1": Vector2(70, 600),
		"spawn2": Vector2(140, 600),
		"goal": Rect2(1720, 560, 90, 90),
	}

static func _level2() -> Dictionary:
	return {
		"name": "Level 2",
		"size": Vector2(2200, 720),
		"bg_color": Color(0.50, 0.72, 0.90),
		"platforms": [
			Rect2(0, 650, 420, 70),
			Rect2(540, 650, 360, 70),
			Rect2(1000, 560, 220, 30),
			Rect2(1320, 480, 220, 30),
			Rect2(1640, 650, 560, 70),
		],
		"crates": [],
		"spawn1": Vector2(70, 600),
		"spawn2": Vector2(140, 600),
		"goal": Rect2(2100, 560, 90, 90),
	}

static func _level3() -> Dictionary:
	return {
		"name": "Level 3",
		"size": Vector2(2200, 720),
		"bg_color": Color(0.45, 0.66, 0.86),
		"platforms": [
			Rect2(0, 650, 600, 70),
			Rect2(780, 650, 500, 70),
			Rect2(1280, 520, 920, 70),
		],
		"crates": [Vector2(1150, 500)],
		"spawn1": Vector2(70, 600),
		"spawn2": Vector2(140, 600),
		"goal": Rect2(2140, 430, 90, 90),
	}

static func _level4() -> Dictionary:
	return {
		"name": "Level 4",
		"size": Vector2(2600, 720),
		"bg_color": Color(0.40, 0.60, 0.82),
		"platforms": [
			Rect2(0, 650, 500, 70),
			Rect2(640, 650, 420, 70),
			Rect2(1140, 520, 420, 70),
			Rect2(1640, 520, 300, 70),
			Rect2(2020, 380, 580, 70),
		],
		"crates": [Vector2(980, 470), Vector2(1880, 330)],
		"spawn1": Vector2(70, 600),
		"spawn2": Vector2(140, 600),
		"goal": Rect2(2540, 290, 90, 90),
	}

static func _level5() -> Dictionary:
	return {
		"name": "Level 5",
		"size": Vector2(3000, 760),
		"bg_color": Color(0.35, 0.55, 0.78),
		"platforms": [
			Rect2(0, 690, 460, 70),
			Rect2(590, 690, 300, 70),
			Rect2(980, 600, 180, 30),
			Rect2(1230, 520, 180, 30),
			Rect2(1480, 690, 360, 70),
			Rect2(1940, 690, 420, 70),
			Rect2(2440, 560, 560, 70),
		],
		"crates": [Vector2(2340, 500)],
		"spawn1": Vector2(70, 640),
		"spawn2": Vector2(140, 640),
		"goal": Rect2(2900, 470, 90, 90),
	}
