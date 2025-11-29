extends Node3D

@onready var anim: AnimationPlayer = $AnimationPlayer
var is_closed: bool = true


func interact():
	if anim.is_playing():
		return

	if is_closed:
		anim.play("Open")
		is_closed = false
	else:
		anim.play("Close")
		is_closed = true
