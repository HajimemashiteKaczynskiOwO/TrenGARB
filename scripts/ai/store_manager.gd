extends Node3D

@onready var timer_node: Node = $"../../TimerNode"
@onready var cars_node: Node3D = $"../CustomerNode/Cars"
@onready var customer_spawner: Node3D = $"../CustomerSpawner"   # your existing one
@export var door_point: Marker3D = null

# how often (in game hours) to check for possible arrivals
const CHECK_INTERVAL_HOURS := 0.1
# probability a customer arrives each check (0.0–1.0)
const ARRIVAL_CHANCE := 1

var last_check_hour: float = 0.0
var rng := RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func _process(_delta):
	if not timer_node or not timer_node.running:
		
		return

	var current_hours = timer_node.game_time_seconds / timer_node.SECONDS_PER_HOUR

	# wait until after midnight
	if current_hours < 0.0:
		return

	# check every 0.5 in-game hours
	if current_hours - last_check_hour >= CHECK_INTERVAL_HOURS:
		last_check_hour = current_hours
		_try_spawn_customer()

func _try_spawn_customer():
	if rng.randf() <= ARRIVAL_CHANCE:

		_spawn_random_car_customer()

func _spawn_random_car_customer():
	# pick a random car that is idle (no current animation playing)
	var cars = cars_node.get_children()
	var available = []
	for c in cars:
		if c.has_node("AnimationPlayer"):
			var anim = c.get_node("AnimationPlayer") as AnimationPlayer
			if not anim.is_playing():
				available.append(c)

	if available.is_empty():
		print("🚫 No idle cars to spawn.")
		return

	var car = available[rng.randi_range(0, available.size() - 1)]
	var car_name = car.name

	# pick its correct animation
	var anim_player = car.get_node("AnimationPlayer") as AnimationPlayer
	var anim_name = ""
	match car_name:
		"Car1": anim_name = "driveIn"
		"Car2": anim_name = "driveIn2"
		"Car3": anim_name = "driveIn3"
		"Car4": anim_name = "driveIn4"
		_: anim_name = "DriveIn1"

	anim_player.play(anim_name)

	# after animation finishes, trigger customer spawn
	await anim_player.animation_finished
	customer_spawner._on_car_drive_in(car, int(car_name.substr(-1, 1)))  # pass index
