extends Button
@onready var panelPanel = $Panel

func _on_pressed():
	panelPanel.visible = not panelPanel.visible


func _on_check_box_toggled(toggled_on): #yea ima fix
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
