extends Node3D

@onready var store_manager: Node3D = get_tree().get_first_node_in_group("store_manager")
@onready var cars_node: Node3D = $"../CustomerNode/Cars"
@onready var customers_parent: Node3D = $"../CustomerNode/Customers" # where Customer1, Customer2, etc. live
@export var door_point : Marker3D = null
var maxCustomers = 3

func _ready():
	# Hide all customers initially
	print("cars_node path:", cars_node.get_path())
	for c in customers_parent.get_children():
		c.visible = false
		c.set_process(false)
		c.set_physics_process(false)

	# Connect car signals
	for i in range(cars_node.get_child_count()):
		var car = cars_node.get_child(i)
		if car.has_signal("drive_in_finished"):
			car.drive_in_finished.connect(_on_car_drive_in.bind(i + 1))

func _on_car_drive_in(car_node: Node3D, parking_index: int):
	var customer := _get_free_customer()
	if customer == null:
		return

	var idx_from_name: int = -1
	if car_node.name.begins_with("Car"):
		idx_from_name = int(car_node.name.substr(3))
	var final_idx: int = parking_index if parking_index > 0 else (idx_from_name if idx_from_name > 0 else 1)

	var marker_path: String = "CarMarkers/CarMarker%d" % final_idx
	var marker: Node3D = cars_node.get_node_or_null(marker_path)
	customer.global_transform.origin = marker.global_transform.origin if marker else car_node.global_transform.origin + Vector3(0, 0, 1.5)

	customer.visible = true
	customer.set_process(true)
	customer.set_physics_process(true)
	customer.set_origin_car(car_node, final_idx)

	# assign door reference FIRST
	if store_manager.has_node("Door"):
		var door_ref = store_manager.get_node("Door")
		if customer.has_method("set_door_node"):
			customer.set_door_node(door_ref)
		else:
			customer.door_node = door_ref
	
	if store_manager and store_manager.door_point:
		print("🧭 Sending", customer.name, "to door:", store_manager.door_point.global_transform.origin)
		if customer.moving:
			print("⚠️", customer.name, "is already moving — skipping duplicate walk_to_door() call.")
			return
		customer.walk_to_door(store_manager.door_point.global_transform.origin)
	else:
		print("❌ No door_point found on store_manager")

func _get_free_customer() -> Node:
	for c in customers_parent.get_children():
		if not c.is_inside_tree():
			continue
		if not c.visible: # treat invisible as “free”
			return c
	return null
