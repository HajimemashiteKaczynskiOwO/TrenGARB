extends CharacterBody3D

@onready var navAgent = $NavigationAgent3D
@onready var skeleton_3d = $"Walker/Skeleton3D"
@onready var animPlayer = $"Walker/AnimationPlayer"

@export var box : Sprite2D = null
@onready var all = $"../../../CanvasLayer"



var SPEED = 1.5
var ROTATION_SPEED = 10.0

func _ready():
	animPlayer.play("Idle")

func _physics_process(delta):
	var current_loc = global_transform.origin
	var next_loc = navAgent.get_next_path_position()
	var new_vel = (next_loc - current_loc).normalized() * SPEED
	
	velocity = new_vel
	move_and_slide()
	
	# Handle animation based on movement
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

func _on_col_end_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	darkness()

func darkness():
	all.visible = false
	box.visible = true
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://scenes/finalScene.tscn")
	
