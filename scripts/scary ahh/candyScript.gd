extends MeshInstance3D
var hasTouched = false
@onready var animP = $AnimationPlayer


func _on_area_3d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if not hasTouched:
		animP.play("driveScare2")
		hasTouched = true
	else:
		pass
