extends Node

func _on_pressed():
	get_tree().change_scene_to_file("res://scene1.tscn")

func _on_quit_button_pressed():
	get_tree().quit()


func _on_options_button_pressed():
	pass # Replace with function body.
