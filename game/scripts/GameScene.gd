class_name GameScene
extends Control

const PlayerScript := preload("res://scripts/Player.gd")
const FollowCameraScript := preload("res://scripts/FollowCamera.gd")
const LevelsScript := preload("res://scripts/Levels.gd")

const TEX_PLAYER1 := preload("res://assets/characters/player1_blue.png")
const TEX_PLAYER2 := preload("res://assets/characters/player2_pink.png")
const TEX_GROUND := preload("res://assets/tiles/ground_grass.png")
const TEX_CRATE := preload("res://assets/tiles/crate.png")
const TEX_SKY := preload("res://assets/backgrounds/sky.png")

const TILE := 48.0
const PLAYER_SIZE := Vector2(48, 48)
const CRATE_SIZE := Vector2(50, 50)

var world: Node2D
var player1: PlayerScript
var player2: PlayerScript
var level_data: Dictionary
var goal_rect: Rect2
var level_complete := false

var viewport1: SubViewport
var viewport2: SubViewport
var camera1: FollowCameraScript
var camera2: FollowCameraScript
var pause_panel: Control

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	level_data = LevelsScript.all()[GameState.current_level]

	_build_split_view()
	_build_pause_panel()

func _unhandled_input(event: InputEvent) -> void:
	if level_complete:
		return
	if event.is_action_pressed("ui_cancel"):
		_set_paused(not get_tree().paused)

func _process(_delta: float) -> void:
	if level_complete or get_tree().paused:
		return

	if goal_rect.has_point(player1.global_position) and goal_rect.has_point(player2.global_position):
		_on_level_finished()
		return

	var fall_limit: float = level_data.size.y + 200.0
	if player1.global_position.y > fall_limit:
		player1.respawn()
	if player2.global_position.y > fall_limit:
		player2.respawn()

# ---------------------------------------------------------------------------
# Split-screen construction
# ---------------------------------------------------------------------------

func _build_split_view() -> void:
	var box := BoxContainer.new()
	box.name = "ViewportsBox"
	box.vertical = (GameState.split_orientation == GameState.SplitOrientation.STACKED)
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(box)

	var pane1 := SubViewportContainer.new()
	pane1.stretch = true
	pane1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pane1.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(pane1)

	viewport1 = SubViewport.new()
	viewport1.handle_input_locally = false
	pane1.add_child(viewport1)

	world = Node2D.new()
	viewport1.add_child(world)
	_populate_world()

	camera1 = FollowCameraScript.new()
	viewport1.add_child(camera1)
	_configure_camera(camera1)
	camera1.target = player1
	camera1.make_current()

	var pane2 := SubViewportContainer.new()
	pane2.stretch = true
	pane2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pane2.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(pane2)

	viewport2 = SubViewport.new()
	viewport2.handle_input_locally = false
	viewport2.world_2d = viewport1.world_2d
	pane2.add_child(viewport2)

	camera2 = FollowCameraScript.new()
	viewport2.add_child(camera2)
	_configure_camera(camera2)
	camera2.target = player2
	camera2.make_current()

func _configure_camera(cam: FollowCameraScript) -> void:
	cam.limit_left = 0
	cam.limit_top = 0
	cam.limit_right = int(level_data.size.x)
	cam.limit_bottom = int(level_data.size.y)
	cam.position_smoothing_enabled = true
	cam.position_smoothing_speed = 6.0
	cam.zoom = Vector2(1.15, 1.15)

# ---------------------------------------------------------------------------
# World population
# ---------------------------------------------------------------------------

func _populate_world() -> void:
	world.add_child(_make_background(level_data.size))

	for rect in level_data.platforms:
		world.add_child(_make_platform(rect))

	for pos in level_data.crates:
		world.add_child(_make_crate(pos))

	world.add_child(_make_goal_marker(level_data.goal))
	goal_rect = level_data.goal

	player1 = _make_player(GameState.ControlScheme.ARROWS, TEX_PLAYER1, level_data.spawn1)
	player2 = _make_player(GameState.ControlScheme.WASD, TEX_PLAYER2, level_data.spawn2)
	world.add_child(player1)
	world.add_child(player2)

# Tiles `texture` across `area_size` starting at local position `top_left`,
# scaled so each tile is TILE x TILE world pixels.
func _tile_grid(parent: Node2D, top_left: Vector2, area_size: Vector2, texture: Texture2D) -> void:
	var tex_size := texture.get_size()
	var scale_factor := Vector2(TILE / tex_size.x, TILE / tex_size.y)
	var cols := int(ceil(area_size.x / TILE))
	var rows := int(ceil(area_size.y / TILE))
	for row in range(rows):
		for col in range(cols):
			var spr := Sprite2D.new()
			spr.texture = texture
			spr.centered = false
			spr.scale = scale_factor
			spr.position = top_left + Vector2(col * TILE, row * TILE)
			parent.add_child(spr)

func _make_background(size: Vector2) -> Node2D:
	var bg := Node2D.new()
	bg.z_index = -10
	_tile_grid(bg, Vector2.ZERO, size, TEX_SKY)
	return bg

func _make_platform(rect: Rect2) -> StaticBody2D:
	var body := StaticBody2D.new()
	body.position = rect.position + rect.size / 2.0

	var shape := RectangleShape2D.new()
	shape.size = rect.size
	var coll := CollisionShape2D.new()
	coll.shape = shape
	body.add_child(coll)

	_tile_grid(body, -rect.size / 2.0, rect.size, TEX_GROUND)

	return body

func _make_crate(pos: Vector2) -> RigidBody2D:
	var body := RigidBody2D.new()
	body.position = pos
	body.lock_rotation = true
	body.mass = 1.5

	var mat := PhysicsMaterial.new()
	mat.friction = 1.0
	body.physics_material_override = mat

	var shape := RectangleShape2D.new()
	shape.size = CRATE_SIZE
	var coll := CollisionShape2D.new()
	coll.shape = shape
	body.add_child(coll)

	var tex_size := TEX_CRATE.get_size()
	var spr := Sprite2D.new()
	spr.texture = TEX_CRATE
	spr.scale = Vector2(CRATE_SIZE.x / tex_size.x, CRATE_SIZE.y / tex_size.y)
	body.add_child(spr)

	return body

func _make_player(scheme: int, texture: Texture2D, spawn: Vector2) -> PlayerScript:
	var p: PlayerScript = PlayerScript.new()
	p.control_scheme = scheme
	p.spawn_point = spawn
	p.position = spawn

	var shape := RectangleShape2D.new()
	shape.size = PLAYER_SIZE
	var coll := CollisionShape2D.new()
	coll.shape = shape
	p.add_child(coll)

	var tex_size := texture.get_size()
	var spr := Sprite2D.new()
	spr.texture = texture
	spr.scale = Vector2(PLAYER_SIZE.x / tex_size.x, PLAYER_SIZE.y / tex_size.y)
	p.add_child(spr)

	return p

func _make_goal_marker(rect: Rect2) -> Node2D:
	var marker := Node2D.new()
	marker.position = rect.position

	var vis := ColorRect.new()
	vis.size = rect.size
	vis.color = Color(0.25, 0.85, 0.35, 0.55)
	vis.mouse_filter = Control.MOUSE_FILTER_IGNORE
	marker.add_child(vis)

	var label := Label.new()
	label.text = "GOAL"
	label.position = Vector2(rect.size.x / 2.0 - 22.0, -26.0)
	marker.add_child(label)

	return marker

# ---------------------------------------------------------------------------
# Pause / level complete
# ---------------------------------------------------------------------------

func _build_pause_panel() -> void:
	pause_panel = _make_overlay_panel("Paused", [
		["Resume", func(): _set_paused(false)],
		["Restart Level", func(): _restart_level()],
		["Quit to Menu", func(): _quit_to_menu()],
	])

func _set_paused(p: bool) -> void:
	get_tree().paused = p
	pause_panel.visible = p

func _on_level_finished() -> void:
	level_complete = true
	get_tree().paused = true

	var is_last: bool = GameState.current_level >= LevelsScript.all().size() - 1
	var actions: Array = []
	if not is_last:
		actions.append(["Next Level", func():
			GameState.current_level += 1
			_restart_level()
		])
	actions.append(["Back to Menu", func(): _quit_to_menu()])

	var title := "You beat DuoJump!" if is_last else "Level Complete!"
	_make_overlay_panel(title, actions).visible = true

func _restart_level() -> void:
	GameState.start_game_requested.emit()

func _quit_to_menu() -> void:
	GameState.return_to_menu_requested.emit()

func _make_overlay_panel(title_text: String, actions: Array) -> Control:
	var overlay := ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.6)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.visible = false
	overlay.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(overlay)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.process_mode = Node.PROCESS_MODE_ALWAYS
	overlay.add_child(center)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	center.add_child(vbox)

	var label := Label.new()
	label.text = title_text
	label.add_theme_font_size_override("font_size", 36)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(label)

	for action in actions:
		var btn := Button.new()
		btn.text = action[0]
		btn.custom_minimum_size = Vector2(180, 40)
		btn.pressed.connect(action[1])
		vbox.add_child(btn)

	return overlay
