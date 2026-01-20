extends Area2D
@onready var sprite := $AnimatedSprite2D
@onready var label = $"../CanvasLayer/Label"
var player_inside := false

func _ready():
	print("READY")
	sprite.play()

func _unhandled_input(event):
	if player_inside and event.is_action_pressed("interact"):
		# Defer the scene change to avoid issues
		call_deferred("change_to_intro")

func change_to_intro():
	get_tree().change_scene_to_file("res://scenes/intros/intro1.tscn")

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	label.text = "PRESS [E] TO KILL"
	player_inside = true
	
func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	label.text = ""
	player_inside = false
