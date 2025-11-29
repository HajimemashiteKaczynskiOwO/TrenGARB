extends Control
@onready var con = $Button

func _on_video_stream_player_finished():
	con.visible = true


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scene1.tscn")
