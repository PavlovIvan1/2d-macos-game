class_name MainMenu
extends Control

const LevelsScript := preload("res://scripts/Levels.gd")

var level_buttons: Array[Button] = []

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

	var bg := ColorRect.new()
	bg.color = Color(0.09, 0.11, 0.16)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 18)
	center.add_child(vbox)

	var title := Label.new()
	title.text = "DuoJump"
	title.add_theme_font_size_override("font_size", 52)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Player 1: Arrow Keys to move / jump      Player 2: A D to move, W to jump"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(subtitle)

	var hint := Label.new()
	hint.text = "Push crates by walking into them. Reach the goal together. Esc pauses."
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.modulate = Color(0.75, 0.75, 0.8)
	vbox.add_child(hint)

	var level_label := Label.new()
	level_label.text = "Select level"
	level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(level_label)

	var level_row := HBoxContainer.new()
	level_row.alignment = BoxContainer.ALIGNMENT_CENTER
	level_row.add_theme_constant_override("separation", 8)
	vbox.add_child(level_row)

	var level_count := LevelsScript.all().size()
	for i in range(level_count):
		var btn := Button.new()
		btn.text = str(i + 1)
		btn.toggle_mode = true
		btn.button_pressed = (i == GameState.current_level)
		btn.custom_minimum_size = Vector2(48, 48)
		btn.pressed.connect(_on_level_selected.bind(i, btn))
		level_row.add_child(btn)
		level_buttons.append(btn)

	var split_row := HBoxContainer.new()
	split_row.alignment = BoxContainer.ALIGNMENT_CENTER
	split_row.add_theme_constant_override("separation", 8)
	vbox.add_child(split_row)

	var split_label := Label.new()
	split_label.text = "Split screen:"
	split_row.add_child(split_label)

	var split_option := OptionButton.new()
	split_option.add_item("Side by side", GameState.SplitOrientation.SIDE_BY_SIDE)
	split_option.add_item("Top / bottom", GameState.SplitOrientation.STACKED)
	split_option.selected = GameState.split_orientation
	split_option.item_selected.connect(_on_split_changed)
	split_row.add_child(split_option)

	var play_btn := Button.new()
	play_btn.text = "Play"
	play_btn.custom_minimum_size = Vector2(160, 44)
	play_btn.pressed.connect(_on_play_pressed)
	vbox.add_child(play_btn)

	var quit_btn := Button.new()
	quit_btn.text = "Quit"
	quit_btn.pressed.connect(func(): get_tree().quit())
	vbox.add_child(quit_btn)

func _on_level_selected(i: int, btn: Button) -> void:
	GameState.current_level = i
	for b in level_buttons:
		b.button_pressed = (b == btn)

func _on_split_changed(idx: int) -> void:
	GameState.split_orientation = idx

func _on_play_pressed() -> void:
	GameState.start_game_requested.emit()
