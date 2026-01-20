extends MeshInstance3D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var trash : MeshInstance3D = self
@onready var colshape = $headThrowBody/CollisionShape3D

var is_closed: bool = true


func interact():
	if anim.is_playing():
		return

	if is_closed:
		anim.play("Open")
		is_closed = false
		trash.add_to_group("interactable")
		colshape.disabled = false
	else:
		anim.play("Close")
		is_closed = true
