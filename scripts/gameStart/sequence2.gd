extends Control
@onready var con = $Button
var level1 = "res://scene1.tscn"
var level2 = "res://scene2.tscn"
var nextLvl = null

func _on_video_stream_player_finished():
	con.visible = true

func _ready():
	match nightCheck.night:
		0:
			nextLvl = level1 
			
		1:
			nextLvl = "res://scene2.tscn"
			con.text = "BEGIN YOUR SECOND SHIFT"
		2:
			nextLvl = level2
			con.text = "BEGIN YOUR THIRD SHIFT"
		3:
			nextLvl = level2 
			con.text = "BEGIN YOUR FOURTH SHIFT"
		4:
			nextLvl = level2
			
	print("next level is level " + nextLvl)
func _on_button_pressed():
	get_tree().change_scene_to_file(nextLvl)
