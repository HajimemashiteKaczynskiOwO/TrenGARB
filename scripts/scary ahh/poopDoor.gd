extends MeshInstance3D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var iLabel = $"../../../CanvasLayer/interactLabel"
@onready var doorLock = $AudioStreamPlayer3D

var is_closed: bool = true


func interact():
	print("hai")
	doorLock.play()
	iLabel.text = "The door is locked."
	await get_tree().create_timer(2).timeout
	iLabel.text = ""
