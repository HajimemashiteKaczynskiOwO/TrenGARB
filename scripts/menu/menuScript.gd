extends CanvasLayer

@onready var menu = $menu
@onready var crosshair = $crossHair

func _input(event):
	if event.is_action_pressed("menu"):
		get_tree().paused = not get_tree().paused
		crosshair.visible = not crosshair.visible
		menu.visible = not menu.visible
		
		if get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _on_play_button_pressed():
	print("Clicked test button!")
	crosshair.visible = true
	get_tree().paused = false
	menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #hides the cursor when you press play again


func _on_quit_2_button_pressed():
	get_tree().quit()


# TIME PLACE

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var time_label: Label = $TimeLabel

func _process(delta: float) -> void:
	time_label.text = globScript.get_game_time()
