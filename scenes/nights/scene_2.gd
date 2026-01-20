extends Node3D
func _ready():
	nightCheck.night = 1  # Completed night 1, starting night 2
	save_progress()

func save_progress():
	var config = ConfigFile.new()
	config.set_value("Progress", "CurrentNight", nightCheck.night)
	config.save("user://save_data.cfg")
