extends "res://addons/addons/stairs-body/stairs_character_body_3d.gd"

# --- Headbob Settings ---
@export var playerHeight := 0.8
@export_group("headbob")
@export var headbob_frequency = 2.0
@export var headbob_amplitude = 0.04
var headbob_time := 0.0
# --- Player settings ---
var speed := 5.0
var jump_speed := 5.0
var gravity := 9.82
var mouse_sensitivity := 0.002

# --- Internal ---
var camera_pitch := 0.0

func _ready():
	# Capture the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# --- Yaw (rotate player) ---
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# --- Pitch (rotate camera) ---
		camera_pitch -= event.relative.y * mouse_sensitivity
		camera_pitch = clamp(camera_pitch, -deg_to_rad(70), deg_to_rad(70))
		$Camera3D.rotation.x = camera_pitch

func _physics_process(delta):
	# --- Gravity ---
	super(delta)  # let the stair stepping code run first
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	# --- Movement input ---
	var input_vec := Input.get_vector("left", "right", "forward", "back")
	
	# Transform input to world space and normalize diagonal movement
	var direction := (transform.basis * Vector3(input_vec.x, 0, input_vec.y))
	if direction.length() > 0:
		direction = direction.normalized() * speed
	else:
		direction = Vector3.ZERO

	velocity.x = direction.x
	velocity.z = direction.z
	
	# --- Headbob update ---
	headbob_time += delta * velocity.length() * float(is_on_floor())
	$Camera3D.transform.origin = Vector3(0, playerHeight, 0) + headbob(headbob_time)

func headbob(time: float) -> Vector3:
	var headbob_position = Vector3.ZERO
	headbob_position.y = (
		sin(time * headbob_frequency) +
		cos(time * headbob_frequency / 2.0)
	) * headbob_amplitude
	return headbob_position


func _on_quit_2_button_pressed(): #yea idk why i put it here i was lazy my bad
		get_tree().paused = false
		get_tree().change_scene_to_file("res://mainMenu.tscn")


@onready var raycast = $Camera3D/RayCast3D
@onready var InteractLabel = $"../../CanvasLayer/Label"
#got damn doors opening and shit
func _process(delta: float) -> void:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		var node = collider
		while node != null:
			if node.has_method("interact"):
				InteractLabel.text = "Press [E] to open/close"
				if Input.is_action_just_pressed("interact"):
					node.interact()
				break
			node = node.get_parent()
	else:
		InteractLabel.text = ""
