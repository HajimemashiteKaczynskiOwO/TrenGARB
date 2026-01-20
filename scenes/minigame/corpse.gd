extends AnimatedSprite2D

func _ready():
	play("default")
	get_tree().paused = false


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("hi")
