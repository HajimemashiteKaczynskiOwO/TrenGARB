# TimerNode.gd
extends Node

@export var endNode : Control = null
@export var VSP : VideoStreamPlayer = null
@export var ASP : AudioStreamPlayer2D = null
signal time_passed

var game_time_seconds: float = 0.0
const SECONDS_PER_HOUR: float = 3
const HOURS_IN_DAY: int = 6
var running: bool = false

func _ready():
	set_process(false) # ensure it doesn’t start until clock-in
	game_time_seconds = 0.0

func _process(delta: float):
	if running:
		game_time_seconds += delta
		
		var current_hour = int(game_time_seconds / SECONDS_PER_HOUR)
		if current_hour >= HOURS_IN_DAY and nightCheck.night != 3:
			running = false
			night_passed()
		elif nightCheck.night == 3:
			running = false
			
			
func night_passed():
	endNode.visible = true
	ASP.play()
	VSP.play()
	get_tree().paused = true


func start_timer():
	running = true
	set_process(true)

func get_game_time() -> String:
	var hours = int(game_time_seconds / SECONDS_PER_HOUR)
	var minutes = int(fmod(game_time_seconds, SECONDS_PER_HOUR) / SECONDS_PER_HOUR * 60)
	return "%02d" % [hours] + " AM"

func get_hour_progress() -> float:
	return (fmod(game_time_seconds, SECONDS_PER_HOUR) / SECONDS_PER_HOUR) * 100.0


func _on_video_stream_player_finished():
	nightCheck.night_passed()
	get_tree().paused = false
	await get_tree().process_frame
	match nightCheck.night:
		0:
			print("Its 0.")
		1:
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes/minigame/min1.tscn")
		2:
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes/minigame/min2.tscn")
		3:
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes/intros/intro1.tscn")
