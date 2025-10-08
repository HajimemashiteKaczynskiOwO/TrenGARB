extends Button
@onready var panelPanel = $Panel

func _on_pressed():
	panelPanel.visible = not panelPanel.visible
