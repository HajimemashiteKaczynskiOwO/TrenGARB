extends Node

var game_time_seconds: float = 0.0
const SECONDS_PER_HOUR: float = 180.0
const HOURS_IN_DAY: int = 24

func _process(delta: float) -> void:
	game_time_seconds += delta
	if game_time_seconds >= HOURS_IN_DAY * SECONDS_PER_HOUR:
		game_time_seconds = 0

func get_game_time() -> String:
	var total_hours = int(game_time_seconds / SECONDS_PER_HOUR)
	var minutes = int((fmod(game_time_seconds, SECONDS_PER_HOUR) / SECONDS_PER_HOUR) * 60)
	return "%02d:%02d" % [total_hours, minutes]
	

func get_hour_progress() -> float:
	# Return percentage through current hour (0–100)
	return (fmod(game_time_seconds, SECONDS_PER_HOUR) / SECONDS_PER_HOUR) * 100.0
	
