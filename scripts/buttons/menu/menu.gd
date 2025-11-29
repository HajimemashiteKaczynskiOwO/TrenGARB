extends Control
@onready var menuButt = $"."
func _process(delta):
	if Input.is_action_just_pressed("menu"):
		menuButt.visible = !menuButt.visible
		get_tree().paused = menuButt.visible		
func _on_quit_2_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://mainMenu.tscn")


func _on_play_button_pressed():
	menuButt.visible = false
	get_tree().paused = false


func _on_skip_button_pressed():
	get_tree().change_scene_to_file("res://scene1.tscn")
