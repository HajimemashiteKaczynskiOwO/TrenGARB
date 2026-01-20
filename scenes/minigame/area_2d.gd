extends Area2D

@onready var sprite := $AnimatedSprite2D

func _ready():
	print("READY")
	get_tree().paused = false
	sprite.play()
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	get_tree().change_scene_to_file("res://scenes/intros/intro1.tscn")
	
	
