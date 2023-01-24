extends CharacterBody3D


const SPEED = 5.0
const RUN_SPEED = 10.0
const JUMP_VELOCITY = 8
var toggled_camera = false
const MOUSE_SENSITIVITY = 0.25
var mouse_zoom = 5
const MIN_ZOOM = 20
const MAX_ZOOM = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func camera_rotate_y(amount):
	rotation_degrees.y += amount
func camera_rotate_x(amount):
	$SpringArm3D.rotation_degrees.x += amount
	if $SpringArm3D.rotation_degrees.x > 90:
		$SpringArm3D.rotation_degrees.x = 90
	if $SpringArm3D.rotation_degrees.x < -90:
		$SpringArm3D.rotation_degrees.x = -90

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if toggled_camera:
			camera_rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
			camera_rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
	if Input.is_action_just_released("zoom_in"):
		$SpringArm3D.spring_length = clamp($SpringArm3D.spring_length - 1, MAX_ZOOM, MIN_ZOOM)
	if Input.is_action_just_released("zoom_out"):
		$SpringArm3D.spring_length = clamp($SpringArm3D.spring_length + 1, MAX_ZOOM, MIN_ZOOM)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	#Camera controls
	if toggled_camera:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("camera_lock") or Input.is_action_just_released("camera_lock"):
		toggled_camera = !toggled_camera
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var current_speed = SPEED
	if Input.is_action_pressed("sprint"):
		current_speed = RUN_SPEED
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
