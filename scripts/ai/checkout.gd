extends Node3D

@onready var scan_area: StaticBody3D = $StaticBody3D
@onready var foods_parent: Node3D = $Foods
@onready var label_3d: Label3D = $Label3D
@onready var beep_Player = $AudioStreamPlayer3D
@onready var scanArea = $StaticBody3D/CollisionShape3D

var active_customer = null
var current_items: Array = []
var scanning: bool = false
var customerThere: bool = false

func _ready():
	_hide_all_items()
	label_3d.visible = false
	scan_area.set_meta("ready", false)


# Called by customer when they reach the counter /isnt called rn
func place_items_for_customer(customer, items: Array):
	scanArea.visible = true
	customerThere = true
	if scanning:
		return # still busy

	active_customer = customer
	current_items = items

	_hide_all_items()

	# Make the correct number of items visible
	for i in range(items.size()):
		var node_name = "Item%d" % (i + 1)
		if foods_parent.has_node(node_name):
			foods_parent.get_node(node_name).visible = true

	scan_area.set_meta("ready", true)
	label_3d.text = "Ready to scan"
	label_3d.visible = true

func start_scanning():
	if scanning:
		return
	if current_items.size() == 0:
		return

	scanning = true
	label_3d.text = "Scanning..."
	var scan_time = _calculate_scan_time(current_items.size())

	var timer = get_tree().create_timer(scan_time)
	
	for i in range(current_items.size()):
		beep_Player.play()
		await get_tree().create_timer(0.5).timeout

	
	await timer.timeout

	label_3d.text = "Scan complete!"
	scanning = false
	scan_area.set_meta("ready", false)

	await get_tree().create_timer(0.5).timeout
	label_3d.visible = false

	# Tell the customer they’re done
	if active_customer and active_customer.has_method("on_checkout_complete"):
		active_customer.on_checkout_complete()

	_hide_all_items()
	active_customer = null
	current_items.clear()


func _calculate_scan_time(item_count: int) -> float:
	if item_count <= 2:
		return randf_range(1.0, 3.0)
	elif item_count <= 4:
		return randf_range(3.0, 6.0)
	else:
		return randf_range(6.0, 9.0)


func _hide_all_items():
	for child in foods_parent.get_children():
		child.visible = false
		
