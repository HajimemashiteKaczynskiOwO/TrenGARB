extends Control
@onready var finalNight = $VideoStreamPlayer/FinalNight
@onready var cl = $CanvasLayer

func _on_video_stream_player_finished():
	nightCheck.fin = 1
	
	var config = ConfigFile.new()
	config.load("user://save_data.cfg")  
	config.set_value("Progress", "Finished", 1)
	config.set_value("Progress", "CurrentNight", nightCheck.night)  
	config.save("user://save_data.cfg")
	
	cl.visible = true
	finalNight.play()



func _on_final_night_finished():
	get_tree().change_scene_to_file("res://mainMenu.tscn")
