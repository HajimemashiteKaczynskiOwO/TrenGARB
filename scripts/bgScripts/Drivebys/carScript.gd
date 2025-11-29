extends Node

@export var min_driveby_interval: float = 10.0
@export var max_driveby_interval: float = 90.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _timer: float = 0.0
var _next_driveby_time: float = 0.0


func _ready() -> void:
	# randomize shit and pick an initial random interval
	randomize()
	_pick_next_driveby_time()


func _process(delta: float) -> void:
	_timer += delta

	if _timer >= _next_driveby_time:
		_play_driveby()
		_pick_next_driveby_time()


func _play_driveby() -> void:
	var animations = ["carRight_Drive", "carLeft_Drive"]
	var chosen_anim = animations[randi() % animations.size()]

	if animation_player.has_animation(chosen_anim):
		animation_player.play(chosen_anim)
	else:
		push_warning("Animation '%s' not found!" % chosen_anim)


func _pick_next_driveby_time() -> void:
	_timer = 0.0
	_next_driveby_time = randf_range(min_driveby_interval, max_driveby_interval)
