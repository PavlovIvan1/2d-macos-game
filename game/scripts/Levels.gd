class_name Levels
extends RefCounted

# All coordinates are in level/world pixels. Platform rects are (x, y, w, h)
# with y measured downward from the level's top; a platform's y is the top
# of its collision box. Gaps between platform rects are pits: walking off
# one and falling past the level's bottom respawns the player at their spawn.
#
# Physics budget (see Player.gd): max solo jump height ~= 141px.
#   - plain steps/gaps always use height diff <= 90px (big safety margin)
#   - gaps are always <= 150px horizontally (well within jump range)
#   - "walls" that require a crate use exactly a 160px height diff: too
#     tall to solo-jump (141 < 160), but easily cleared once standing on a
#     ~50px crate (141 + 50 = 191 > 160).

static func all() -> Array:
	return [_level1(), _level2(), _level3(), _level4(), _level5()]

static func _level1() -> Dictionary:
	return {
		"name": "Level 1",
		"size": Vector2(1700, 720),
		"bg_color": Color(0.55, 0.78, 0.92),
		"platforms": [
			Rect2(0, 650, 480, 70),
			Rect2(620, 650, 460, 70),
			Rect2(1180, 650, 520, 70),
		],
		"crates": [],
		"spawn1": Vector2(70, 600),
		"spawn2": Vector2(140, 600),
		"goal": Rect2(1590, 560, 90, 90),
	}

static func _level2() -> Dictionary:
	return {
		"name": "Level 2",
		"size": Vector2(2000, 720),
		"bg_color": Color(0.50, 0.72, 0.90),
		"platforms": [
			Rect2(0, 650, 420, 70),
			Rect2(560, 650, 380, 70),
			Rect2(1000, 650, 300, 70),
			Rect2(1360, 570, 260, 20),
			Rect2(1680, 650, 320, 70),
		],
		"crates": [],
		"spawn1": Vector2(70, 600),
		"spawn2": Vector2(140, 600),
		"goal": Rect2(1900, 560, 90, 90),
	}

static func _level3() -> Dictionary:
	return {
		"name": "Level 3",
		"size": Vector2(2300, 720),
		"bg_color": Color(0.45, 0.66, 0.86),
		"platforms": [
			Rect2(0, 650, 600, 70),
			Rect2(750, 650, 480, 70),
			Rect2(1230, 490, 900, 70),
		],
		"crates": [Vector2(1050, 600)],
		"spawn1": Vector2(70, 600),
		"spawn2": Vector2(140, 600),
		"goal": Rect2(2010, 400, 90, 90),
	}

static func _level4() -> Dictionary:
	return {
		"name": "Level 4",
		"size": Vector2(2900, 760),
		"bg_color": Color(0.40, 0.60, 0.82),
		"platforms": [
			Rect2(0, 690, 460, 70),
			Rect2(600, 690, 420, 70),
			Rect2(1020, 530, 380, 70),
			Rect2(1550, 530, 350, 70),
			Rect2(1900, 370, 700, 70),
		],
		"crates": [Vector2(870, 640), Vector2(1750, 480)],
		"spawn1": Vector2(70, 640),
		"spawn2": Vector2(140, 640),
		"goal": Rect2(2480, 280, 90, 90),
	}

static func _level5() -> Dictionary:
	return {
		"name": "Level 5",
		"size": Vector2(3300, 780),
		"bg_color": Color(0.35, 0.55, 0.78),
		"platforms": [
			Rect2(0, 690, 440, 70),
			Rect2(580, 690, 260, 70),
			Rect2(960, 610, 160, 20),
			Rect2(1200, 690, 300, 70),
			Rect2(1650, 690, 350, 70),
			Rect2(2000, 530, 700, 70),
			Rect2(2820, 530, 400, 70),
		],
		"crates": [Vector2(1850, 640)],
		"spawn1": Vector2(70, 640),
		"spawn2": Vector2(140, 640),
		"goal": Rect2(3100, 440, 90, 90),
	}
