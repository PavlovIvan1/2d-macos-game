extends Node

const MainMenuScript := preload("res://scripts/MainMenu.gd")
const GameSceneScript := preload("res://scripts/GameScene.gd")

var current_view: Control = null

func _ready() -> void:
	GameState.start_game_requested.connect(show_game)
	GameState.return_to_menu_requested.connect(show_menu)
	show_menu()

func show_menu() -> void:
	get_tree().paused = false
	_show(MainMenuScript.new())

func show_game() -> void:
	get_tree().paused = false
	_show(GameSceneScript.new())

func _show(view: Control) -> void:
	if current_view:
		current_view.queue_free()
	current_view = view
	view.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(view)
