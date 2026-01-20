extends Node

func _on_pressed():
	# Delete save file to start fresh
	var dir = DirAccess.open("user://")
	if dir.file_exists("save_data.cfg"):
		dir.remove("save_data.cfg")
	
	# Reset night progress
	nightCheck.night = 0
	nightCheck.fin = 0
	
	# Start new game
	get_tree().change_scene_to_file("res://scenes/intros/intro1.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_options_button_pressed():
	pass # Replace with function body.
