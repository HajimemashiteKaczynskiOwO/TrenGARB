extends MeshInstance3D
@onready var scream = $AudioStreamPlayer3D

func _on_area_3d_body_entered(body):
	scream.play()
