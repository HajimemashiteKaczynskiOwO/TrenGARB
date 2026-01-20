extends Node3D
@onready var asp = $"../Door_02/AudioStreamPlayer3D"
@onready var anim: AnimationPlayer = $AnimationPlayer
var is_closed: bool = true


func interact():
	if anim.is_playing():
		return

	if is_closed:
		anim.play("Open")
		asp.play()
		is_closed = false
	else:
		anim.play("Close")
		asp.play()
		is_closed = true
