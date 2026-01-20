extends Control
@onready var menuButt = $"."
@onready var skip = $"../skipButton/skipButton"

var level1 = "res://scene1.tscn"
var level2 = "res://scenes/nights/scene2.tscn"
var level3 = "res://scenes/nights/scene3.tscn"
var level4 = "res://scenes/nights/scene4.tscn"
var nextLvl = null

func _ready():
	match nightCheck.night:
		0:
			nextLvl = level1 
			
		1:
			nextLvl = level2

		2:
			nextLvl = level3

		3:
			nextLvl = level4

		4:
			nextLvl = level2
			
	print("next level is level " + nextLvl)
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
	get_tree().change_scene_to_file(nextLvl)
