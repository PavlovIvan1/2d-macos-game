extends Node

enum SplitOrientation { SIDE_BY_SIDE, STACKED }
enum ControlScheme { ARROWS, WASD }

signal start_game_requested
signal return_to_menu_requested

var split_orientation: SplitOrientation = SplitOrientation.SIDE_BY_SIDE
var current_level: int = 0

func _ready() -> void:
	_bind("p1_left", KEY_LEFT)
	_bind("p1_right", KEY_RIGHT)
	_bind("p1_jump", KEY_UP)
	_bind("p2_left", KEY_A)
	_bind("p2_right", KEY_D)
	_bind("p2_jump", KEY_W)

func _bind(action: String, keycode: Key) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var ev := InputEventKey.new()
	ev.keycode = keycode
	InputMap.action_add_event(action, ev)
