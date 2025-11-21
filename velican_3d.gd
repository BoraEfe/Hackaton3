extends CharacterBody3D

@export var SPEED := 3.5
@export var JUMP_VELOCITY := 4.0
@export var MOUSE_SENSITIVITY := 0.003

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var head: Node3D
var camera: Camera3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	head = $Head
	camera = $Head/Camera3D


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_rotate_camera(event)


func _rotate_camera(event: InputEventMouseMotion) -> void:
	# horizontale rotatie speler
	rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
	
	# verticale rotatie camera (met limiet)
	var new_pitch = clamp(
		head.rotation.x - event.relative.y * MOUSE_SENSITIVITY,
		deg_to_rad(-85),
		deg_to_rad(85)
	)
	head.rotation.x = new_pitch


func _physics_process(delta: float) -> void:
	# zwaartekracht
	if not is_on_floor():
		velocity.y -= gravity * delta

	# springen
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# richtingsinput
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var basis = transform.basis
	var direction = (basis.z * input_dir.y) + (basis.x * input_dir.x)
	direction = direction.normalized()

	# lopen
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
