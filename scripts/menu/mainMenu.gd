extends CanvasLayer
@onready var play_button = $mainMenu/playButton
@onready var continue_button = $mainMenu/continueButton

func _ready():
	match nightCheck.night:
		0:
			pass
		1:
			continue_button.text ="PLAY NIGHT 2"
			continue_button.visible = true
		2:
			continue_button.text ="PLAY NIGHT 3"
			continue_button.visible = true
		3:
			continue_button.text ="PLAY NIGHT 4"
			continue_button.visible = true
		
	if nightCheck.night > 0:
		play_button.text = "START NEW GAME"


func _on_continue_button_pressed():
	match nightCheck.night:
		0:
			pass
		1:
			get_tree().change_scene_to_file("res://scenes/nights/scene2.tscn")
		2:
			get_tree().change_scene_to_file("res://scenes/nights/scene3.tscn")
		3:
			get_tree().change_scene_to_file("res://scenes/nights/scene4.tscn")
		
