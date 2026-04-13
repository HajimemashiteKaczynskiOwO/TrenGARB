extends CharacterBody3D

@onready var navAgent = $NavigationAgent3D
@onready var skeleton_3d = $"Enemy/Skeleton3D"
@onready var animPlayer = $"Enemy/AnimationPlayer"
@onready var all = $"../../../CanvasLayer"


# Optimization
@onready var caps = $MeshInstance3D
@onready var enemy = $Enemy
var mileage = 15

# -----
var SPEED = 3
var ROTATION_SPEED = 10.0
var player = null  


func initialize(pos: Vector3):
	global_position = pos
	
func _ready():
	animPlayer.play("Hunt/IdleANim")
	
	navAgent.path_desired_distance = 0.5
	navAgent.target_desired_distance = 0.5
	

	call_deferred("setup_navigation")
func setup_navigation():
	await get_tree().physics_frame
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		pass

func _physics_process(delta):

	if player != null:
		navAgent.target_position = player.global_position
	

	if navAgent.is_navigation_finished():
		return
	
	var current_loc = global_transform.origin
	var next_loc = navAgent.get_next_path_position()
	var new_vel = (next_loc - current_loc).normalized() * SPEED
	
	velocity = new_vel
	move_and_slide()
	
	if current_loc.distance_to(navAgent.target_position) < mileage:
		_optimize()
	else:
		_deoptimize()
	
	if velocity.length() > 0.1:
		if animPlayer.current_animation != "Hunt/walkANim":
			animPlayer.play("Hunt/walkANim")
		animPlayer.speed_scale = velocity.length() / SPEED * 1.2
		# Rotate to face movement direction
		var look_direction = Vector3(velocity.x, 0, velocity.z).normalized()
		if look_direction.length() > 0.01:
			var target_rotation = atan2(look_direction.x, look_direction.z)
			rotation.y = lerp_angle(rotation.y, target_rotation, ROTATION_SPEED * delta)
	else:
		if animPlayer.current_animation != "Hunt/IdleANim":
			animPlayer.play("Hunt/IdleANim")

func update_target_loc(target_loc) -> void:
	navAgent.target_position = target_loc

func _optimize():
	enemy.visible = true
	caps.visible = false
	
func _deoptimize():
	enemy.visible = false
	caps.visible = true
