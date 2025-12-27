# TimerNode.gd
extends Node

@export var endNode : Control = null
@export var VSP : VideoStreamPlayer = null
@export var ASP : AudioStreamPlayer2D = null

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
		if game_time_seconds >= HOURS_IN_DAY * SECONDS_PER_HOUR:
			night_passed()

			
func night_passed():
	nightCheck.night_passed()
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
	print(nightCheck.night)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/intros/intro1.tscn")
