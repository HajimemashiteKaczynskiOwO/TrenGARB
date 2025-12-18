extends CharacterBody3D

@export var door: NodePath
@export var speed: float = 2.5
@onready var idle_player: AnimationPlayer = $AnimationPlayer2
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var door_node: Node3D = null
@onready var doorAnim = $"../../../StoreManager/Door/AnimationPlayer"
@onready var storeSpots = $"../../../StoreSpots"
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var task : Task = $"../../../Checkout/StaticBody3D"
# CHECKOUT
@onready var checkoutSpot = $"../../../Checkout/checkoutSpot"
@onready var foodParent = $"../../../Checkout/Foods"
@onready var scanBody = $"../../../Checkout/StaticBody3D/CollisionShape3D"

var origin_car: Node3D = null
var origin_parking_index: int = -1
var target_position: Vector3 = Vector3.ZERO
var moving := false
var state := "idle"
var move_timer := 0.0
var waiting_for_player_scan: bool = false

func _ready():
	add_to_group("customer")
	idle_player.play("Idle")

func set_origin_car(car: Node3D, parking_index: int) -> void:
	origin_car = car
	origin_parking_index = parking_index

func set_target(pos: Vector3):
	if moving:
		print(name, "already moving so ignoring new target")
		return
	target_position = pos
	moving = true
	move_timer = 0.0

	# dont override
	if not state.begins_with("walking_"):
		state = "walking"

	anim_player.play("Walk")



func _physics_process(delta):

	if not moving:
		return

	move_timer += delta
	if move_timer > 10.0:
		_arrived()
		return

	nav_agent.set_target_position(target_position)
	if nav_agent.is_navigation_finished():
		_arrived()
		return

	var next_pos = nav_agent.get_next_path_position()
	var dir = (next_pos - global_transform.origin)
	if dir.length() > 0.1:
		dir = dir.normalized()
		velocity = dir * speed
		move_and_slide()
		look_at(global_transform.origin + dir, Vector3.UP)
	else:
		velocity = Vector3.ZERO


func walk_to_door(pos: Vector3):
	print(name, ">>> walk_to_door() called. state before:", state)
	state = "walking_to_door"
	set_target(pos)
	print(name, ">>> walk_to_door() done. state after:", state)



func _arrived():
	if not moving:
		return

	moving = false
	velocity = Vector3.ZERO
	print(name, " arrived! state=", state, " target=", target_position)
	print(name, " arrived at destination. State:", state)
	anim_player.stop()
	idle_player.play("Idle")

	if state == "walking_to_door":
		await _try_open_door()

	elif state == "walking_to_spot":
		var forward_dir = -global_transform.basis.z
		look_at(global_transform.origin + forward_dir, Vector3.UP)
		state = "idle_in_store"
		print(name, "is now idle in store.")
		
		var wait_time = randf_range(5.0, 15.0)
		await get_tree().create_timer(wait_time).timeout

		_walk_to_counter()

	elif state == "walking_to_counter":
		# Customer arrived at checkout counter -> wait for the player
		state = "at_counter"
		print(name, "arrived at checkout counter")
		# face the counter
		var forward_dir = -global_transform.basis.z
		look_at(global_transform.origin + forward_dir, Vector3.UP)

		# tell game logic this customer is ready to be scanned (optional signal / UI hook)
		place_items()

		# mark that we are waiting for player
		waiting_for_player_scan = true
		print(name, "waiting for player to scan...")

		# Wait until the player clears the flag (scanner will set this to false)
		while waiting_for_player_scan:
			await get_tree().process_frame

		print(name, "player scanned items; leaving store")
		leave_store()



	elif state == "walking_to_exit_door":
		# Customer arrived at exit door
		state = "at_exit_door"
		print(name, "arrived at exit door")
		_try_exit_door()

	elif state == "walking_to_car":
		# Customer arrived at car
		_finish_trip()
func _try_open_door() -> void:
	print(name, "is opening the door...")
	state = "opening_door"

	doorAnim.play("Open")
	await get_tree().create_timer(1.5).timeout  # wait for open animation
	print(name, "door opened — walking inside.")
	_walk_to_place()

	await get_tree().create_timer(2.0).timeout
	doorAnim.play("Close")

func _walk_to_place():
	print(name, ">>> _walk_to_place() called")

	var free_spots: Array[Marker3D] = []
	
	for c in storeSpots.get_children():
		if c is Marker3D and not c.visible:
			free_spots.append(c)

	if free_spots.is_empty():
		print(name, " no free store spot found for ", name)
		return

	var free_spot: Marker3D = free_spots[randi() % free_spots.size()]
	free_spot.visible = true
	# Now set their new target
	print(name, "walking to spot:", free_spot.name)
	state = "walking_to_spot"
	set_target(free_spot.global_position)

	# 🔧 Force walking animation start
	idle_player.stop()
	anim_player.play("Walk")

	# Remember which spot they took
	self.set_meta("spot", free_spot)


func _walk_to_counter():
	print(name," walking to CHECK OUT.")
	state = "walking_to_counter"
	set_target(checkoutSpot.global_position)
	
	idle_player.stop()
	anim_player.play("Walk")
	

func place_items():
	#Make Random Amount and Random Item Visible!
	var hidden_markers = []
	for c in foodParent.get_children():
		if c is MeshInstance3D and not c.visible:
			hidden_markers.append(c)
	 
	if hidden_markers.size() > 0:
		var random_marker = hidden_markers[randi() % hidden_markers.size()]
		random_marker.visible = true
		
	if hidden_markers.size() < 3:
		task.task_type = "short"
	else:
		task.task_type = "long"
	
	#After Visible, Activate the Scanning task.
	scanBody.disabled = false
	
	
func leave_store():
	#make all items invis again
	for c in foodParent.get_children():
		if c is MeshInstance3D:
			c.visible = false

	await get_tree().create_timer(randf_range(2.0, 4.0)).timeout
	
	var spot = get_meta("spot")
	if spot and spot is Marker3D:
		spot.visible = false
	
	state = "walking_to_exit_door"
	set_target(-doorAnim.get_parent().global_position) # or door position

func _try_exit_door():
	state = "exiting_door"
	doorAnim.play("Open")
	await get_tree().create_timer(1.2).timeout
	_walk_to_car()
	await get_tree().create_timer(2.0).timeout
	doorAnim.play("Close")

func _walk_to_car():
	if origin_car == null:
		print(name, "has no origin car!")
		queue_free()
		return
	state = "walking_to_car"
	set_target(origin_car.global_position)
	idle_player.stop()
	anim_player.play("Walk")

func _finish_trip():
	nightCheck.pleased_customer()
	print(nightCheck.pleasedCustomer)
	state = "done"
	anim_player.stop()
	idle_player.play("Idle")
	print(name, "reached car — leaving scene.")
	visible = false
	await get_tree().create_timer(1.0).timeout
	queue_free()
