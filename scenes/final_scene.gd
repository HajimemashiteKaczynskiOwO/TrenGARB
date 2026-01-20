extends Control

func _on_video_stream_player_finished():
	nightCheck.fin = 1
	

	var config = ConfigFile.new()
	config.load("user://save_data.cfg")  
	config.set_value("Progress", "Finished", 1)
	config.set_value("Progress", "CurrentNight", nightCheck.night)  
	config.save("user://save_data.cfg")
	
	get_tree().change_scene_to_file("res://mainMenu.tscn")
