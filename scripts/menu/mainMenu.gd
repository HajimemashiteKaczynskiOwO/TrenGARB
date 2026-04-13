extends CanvasLayer
@onready var play_button = $mainMenu/playButton
@onready var continue_button = $mainMenu/continueButton
@onready var finishStar = $Title/FinishStar

func _ready():
	print(nightCheck.fin)
	var config = ConfigFile.new()
	var err = config.load("user://save_data.cfg")
	if err != OK:
		# No save file, hide continue button
		continue_button.visible = false
		nightCheck.night = 0  # Start at night 1
		nightCheck.fin = 0
		finishStar.visible = false
		return
	
	nightCheck.night = config.get_value("Progress", "CurrentNight", 0)
	nightCheck.fin = config.get_value("Progress", "Finished", 0)
	
	print("Loaded nightCheck.fin: ", nightCheck.fin)  # Debug print AFTER loading
	
	# Update star visibility based on loaded value
	finishStar.visible = (nightCheck.fin == 1)
				
	match nightCheck.night:
		0:
			continue_button.visible = false  # No progress yet
		1:
			continue_button.text = "CONTINUE - NIGHT 2"
			continue_button.visible = true
			play_button.text = "START NEW GAME"
		2:
			continue_button.text = "CONTINUE - NIGHT 3"
			continue_button.visible = true
			play_button.text = "START NEW GAME"
		3:
			continue_button.text = "PLAY NIGHT 4"
			continue_button.visible = true
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
