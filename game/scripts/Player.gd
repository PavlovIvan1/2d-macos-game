class_name Player
extends CharacterBody2D

@export var control_scheme: int = GameState.ControlScheme.ARROWS
var spawn_point: Vector2 = Vector2.ZERO

const SPEED := 240.0
const JUMP_VELOCITY := -650.0
const GRAVITY := 1500.0

# Max jump height = JUMP_VELOCITY^2 / (2*GRAVITY) =~ 141 px.
# Levels keep plain ledge/step height differences <= 90px (big margin),
# and gate anything >= 150px behind a crate (crate top ~= +50px of extra
# reach, so crate + jump clears up to ~190px, comfortably above 150).

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	var left_action := "p1_left" if control_scheme == GameState.ControlScheme.ARROWS else "p2_left"
	var right_action := "p1_right" if control_scheme == GameState.ControlScheme.ARROWS else "p2_right"
	var jump_action := "p1_jump" if control_scheme == GameState.ControlScheme.ARROWS else "p2_jump"

	var direction := Input.get_axis(left_action, right_action)
	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)

	if is_on_floor() and Input.is_action_just_pressed(jump_action):
		velocity.y = JUMP_VELOCITY

	move_and_slide()

func respawn() -> void:
	global_position = spawn_point
	velocity = Vector2.ZERO
